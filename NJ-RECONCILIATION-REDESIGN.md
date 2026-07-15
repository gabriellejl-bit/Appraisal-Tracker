# NJ Statement Reconciliation Redesign — Spec & Prompt for a Fresh Session

## How to use this document

Paste this whole file as the opening prompt in a **new** Claude Code session in this repo. That session has no memory of the conversation that produced this spec — everything it needs is below or in `CLAUDE.md`/`PROJECT.md`, which it should read first. Do not summarize this doc back before starting; read it, read `CLAUDE.md` and `PROJECT.md`, then propose an implementation plan (this is a schema + business-logic change, so use plan mode) before writing code.

**This session should not proceed past planning until the open decisions in the "Decisions needed from Gabby" section are resolved with her.** They are genuine design choices, not implementation details — don't guess at them.

---

## 1. Business context (read `PROJECT.md`'s "Nationwide Jewellers — Statement, Credit Notes & Reconciliation" section first for the full picture)

Gabby invoices Nationwide Jewellers' sub-customers directly (one `tax_invoices` row per shipment, full cost). Once a month she consolidates all outstanding tax invoices into a single **Statement** sent to Nationwide. Nationwide pays the statement total *minus* an 8.5% commission they keep — Gabby records that 8.5% as a **credit note**, generated automatically when the statement is marked Paid.

## 2. The design flaw this redesign fixes

The current implementation (built across two sessions, entirely in `AppraisalTracker-dev.html`, never shipped to prod) models each statement as **carrying forward the previous statement's lump total**, rather than tracking payment status on individual tax invoices. Concretely:

- `njLinePool()` (the function that decides what's eligible for the next statement) includes a synthetic `type:'brought_forward'` line for any prior `status='final'` statement not yet "swept" onto a later one, and a synthetic `type:'payment'` line computed as `(that statement's total) − (its credit note's total)`.
- Both of these are **derived from another `nj_statements` row's own stored `subtotal`/`gst`/`total` fields** — not from summing individual unpaid `tax_invoices` rows.
- **This is the bug class that kept resurfacing this session:** when one statement's stored total was wrong (a double-counting bug in the payment sweep — since fixed in isolation, but the flawed *design* that made it possible is still there), every later statement that carried it forward inherited the wrong number, with no way to trace back to which invoice was actually the problem. A second, separate bug (`voidNJStatement()` never deleting `nj_statement_lines` rows) also had to be patched to stop voided statements' carried-forward lines from behaving inconsistently.
- There is **no payment/paid-status tracking on `tax_invoices` or `nj_credit_notes` at all**. Payment is only ever recorded at the whole-statement level (`nj_statements.paid_date`), which is too coarse — you cannot ask "has this specific invoice been paid?" without reconstructing it from a chain of statement-to-statement carry-forward lines.
- Gabby correctly identified this in testing: *"the balance should be a total of all non-paid tax invoices, not something carried forward statement-to-statement."* That is the fix.

**Do not attempt to preserve or extend the `brought_forward`/`payment` line-type mechanism.** It should be deleted, not patched further.

## 3. The corrected model

Track paid status **on the individual `tax_invoices` (and `nj_credit_notes`) rows themselves.** A statement becomes a *report* generated fresh from current data, not a link in a dependent chain.

- **Balance / aging** (what's owed right now) = `SUM(tax_invoices.total where status='active' and paid_date IS NULL)` minus unresolved credit notes — computed live, every time, directly from invoice-level facts. No carry-forward line, no reference to a prior statement's stored total.
- **"New lines" on a statement** (freshly itemized invoice/credit rows, same as today) = invoices/credits not yet *first presented* on any statement — this reuses the existing `tax_invoices.nj_statement_id` / `nj_credit_notes.nj_statement_id` field, but its meaning changes subtly: it now means **"which statement first showed this to Nationwide"**, a permanent historical fact set once and never moved — not "which statement currently owns this," which required the release-then-reattach cycle every time a draft was saved. This eliminates that whole reattachment mechanism.
- **Aging buckets** (Current/30/60/90) bucket every currently-unpaid invoice by *its own* `issue_date`, not by a single lump "opening balance" line dated at some other statement's `generated_date`. This is both more correct and simpler than what's there now — it's also a closer match to the aging report Gabby's reference PDF showed originally.
- **Marking a statement Paid** becomes simple and non-recursive: mark `paid_date` on every currently-unpaid tax invoice as of that point (the whole current balance, since Nationwide pays the full statement total), generate one credit note for 8.5% of what was just marked paid. **No cascade/recursion needed** — because unpaid invoices from two months ago are already part of *this* statement's balance calculation (they never "belonged" to a specific older statement in the first place), there's nothing to chase up a chain. This eliminates the double-payment bug class by construction, not by patching around it.
- **Voiding a statement** reverses exactly what it did: un-bill the packets under its invoices, clear `paid_date` on whichever invoices it had just marked paid (if it was the Paid action being undone), void its credit note. Much simpler than today's version since there's no chain to unwind.

## 4. Database changes

### 4a. Critical: dev and prod have diverged significantly — read this before writing any SQL

The entire NJ Statement feature (`nj_statements`, `nj_statement_lines`, `nj_credit_notes`) **only exists in the dev Supabase project.** It has never been migrated to prod — `index.html` (the prod file) doesn't have this feature at all yet. Additionally, two columns were added to dev-only via ad-hoc `ALTER TABLE` during this session and are **not in prod**:
- `nj_statements.statement_date`
- `shipping_runs.shipping_cost_billed` (`shipping_runs` itself *does* exist in prod — only this one column is dev-only)

**Do not try to replay the incremental history of ALTER TABLE statements that produced dev's current schema.** That history includes columns and a design (`nj_statement_lines.line_type IN ('brought_forward','payment')`, `carried_statement_id`) that this redesign is explicitly removing. Replaying it would recreate the bug.

Instead:
1. Design the **final target schema** for this redesigned feature (see 4b below) and treat dev as needing a clean migration to that target — via `ALTER TABLE`/`DROP COLUMN` on the existing dev tables, not by dropping and recreating them (there is real test data and real learnings in dev worth keeping the tables for, even if you decide to wipe rows — see the open decision on this below).
2. **Only once the redesign is fully built, tested, and confirmed working in dev** should prod's migration be written — and it should be a **single clean set of `CREATE TABLE`/`ALTER TABLE` statements matching the final target schema**, since prod is starting from zero on this feature. Do not write prod SQL until dev is confirmed correct — the two must not diverge again.
3. Every new table needs **RLS explicitly disabled** (or explicit policies) immediately after creation — Supabase's SQL editor can silently enable RLS with no policies, which 403s every request from this app (already bit this project once this session — see `CLAUDE.md`'s pre-delivery checklist).
4. Confirm with Gabby (or check directly) which Supabase project is "dev" vs "prod" before running anything — `AppraisalTracker-dev.html`'s `SB_URL`/`SB_KEY` constants point at dev; `index.html`'s point at prod.

### 4b. Target schema (dev migration; design freely, this is a starting recommendation)

```sql
-- tax_invoices: add paid tracking (this table already exists in both dev and prod)
ALTER TABLE tax_invoices ADD COLUMN paid_date TEXT; -- nullable; set when reconciled against a payment

-- nj_credit_notes: decide paid/applied tracking here — see open decision below before writing this
-- ALTER TABLE nj_credit_notes ADD COLUMN ??? 

-- nj_statement_lines: brought_forward/payment line types and carried_statement_id become dead —
-- decide whether to drop the column or just stop writing to it (see open decision below)
```

`nj_statements` keeps `subtotal`/`gst`/`total` as a **frozen historical snapshot** of what was communicated on that date (useful for audit/reprint), but these fields must never again be read as an *input* to a later statement's balance calculation — only ever written once, at save/finalize time, from a live computation over `tax_invoices`/`nj_credit_notes`.

## 5. Code changes required

All in `AppraisalTracker-dev.html` (never edit `index.html` directly — see `CLAUDE.md`).

- **`njLinePool()`** — remove the `brought_forward` and `payment` blocks entirely, and the `sweptElsewhere()` helper they depend on. Invoice/credit eligibility for "new lines" stays similar (first-presentation gating via `nj_statement_id IS NULL`), but add the separate **balance/aging computation** described in §3, sourced from `paid_date IS NULL` across all active invoices, not just newly-eligible ones.
- **`saveNJDraft()`** — since invoices no longer move between statements once first presented, this can drop the "release everything currently attached, then reattach" cycle for invoice/credit lines. Simplify accordingly.
- **`finalizeNJStatement()`** — mostly unchanged (still bills packets under included invoices), but no longer needs to touch brought-forward/payment line types.
- **`markNJStatementPaid()`** — rewrite per §3: mark `paid_date` on every currently-unpaid invoice, generate the credit note, **no recursion**.
- **`voidNJStatement()`** — simplify per §3; the brought-forward un-cascade logic goes away.
- **`printStatement()`** — the aging bucket computation (`buckets.current/d30/d60/d90`) should source from live unpaid-invoice ages, not from `rowsData` built off frozen `nj_statement_lines` rows of type `brought_forward`/`payment`. Decide whether the printed statement still shows a "Payment received" line item for transparency (probably yes, as a real historical record of what was reconciled against this specific statement) even though it's no longer used as a *calculation input* elsewhere.
- **`renderNJStatementBuilder()`** — remove the `brought_forward`/`payment` row rendering and their type labels; add whatever UI best shows "current balance" vs. "new lines this period" per however the open decisions below land.

## 6. Decisions needed from Gabby before implementation — do not guess at these

1. **Credit notes: do they need their own paid/reconciliation tracking, or are they auto-resolved the moment they're generated?** A credit note represents a deduction Nationwide already took, not something they pay *to* PGL — so it may be correct for it to always count against the balance until voided, with no separate "paid" concept. Confirm this reading with Gabby rather than assuming.
2. **Existing dev test data** (`nj_statements`/`nj_statement_lines`/`nj_credit_notes` rows built under the old carry-forward model) — wipe and start clean, or attempt to migrate/preserve? Given the model is changing structurally, a clean wipe of dev's NJ test data is likely simplest and safest — confirm before deleting anything.
3. **`nj_statement_lines.line_type`/`carried_statement_id`** — drop the column, or leave it unused for now? Leaving it costs nothing short-term; dropping is cleaner. Gabby's call.
4. Should the printed **Statement** still show an explicit "Payment received" line for the period (a real record of what was reconciled), even though the balance calculation no longer depends on it? Recommend yes for transparency/audit trail, but confirm.

## 7. Explicitly out of scope for this redesign

These are known, already-documented, separate issues — do not fix them as part of this work unless Gabby asks:
- Paula's NJ share discount-leak in `buildInvoiceSummary()` (rule 21 in `CLAUDE.md`).
- Credit note numbering (currently references a date range instead of a proper number like `INV-XXXX`).
- Nationwide's Bill-To address on the printed Statement (unconfirmed for NZ-issued statements).

## 8. Verification before calling this done

Follow the `verify` skill / this repo's testing conventions. At minimum, walk through: ship an NJ packet → invoice appears unpaid in the balance → build a statement → finalize → mark Paid → confirm the invoice now shows `paid_date` set and drops out of the next statement's balance, while the credit note appears correctly → void and confirm it reverses cleanly. Update `NJ-BILLING-TESTING.md` (or replace it with a fresh tracking doc for this redesign — your call) as you go, same pattern as the existing file.
