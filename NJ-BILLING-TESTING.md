# Billing Flow Testing Checklist

Tracks testing progress across the Run Billing rebuild (landing screen + invoice-centric NJ statement builder + dedicated Paula entry point). See `.claude/plans/` for the implementation plan this checklist was created alongside.

Status markers: **Not built** / **Built, untested** / **Claude-tested** / **Gabby-tested**

---

## 2026-07-15 — NJ Reconciliation Redesign (payment tracked per-invoice, not carried forward)

Everything below "Flow 2 — Nationwide" in this doc describes the **old** carry-forward/Mark-as-Paid design. That design has been replaced — see `NJ-RECONCILIATION-REDESIGN.md` for the spec and `PROJECT.md`'s "Nationwide Jewellers — Statement" section for the current model. Kept below for historical context (real bugs found in the old design), not as current behavior.

**DB migration required (dev):** new `nj_payments` table, `tax_invoices.paid_date`/`paid_via_payment_id`, `nj_credit_notes.source_payment_id` (replaces `source_statement_id`), `nj_statement_lines.payment_id` (replaces `carried_statement_id`), `nj_statements.opening_balance`/`aging_current`/`aging_30`/`aging_60`/`aging_90`. Existing dev NJ statement/line/credit-note test data wiped as part of the migration (confirmed with Gabby). Full SQL in the implementation plan.

**Claude-tested, end-to-end, against real dev data (6 pre-existing tax invoices, INV-0001–0011):**

| Step | Result |
|---|---|
| Build + Save Draft + Generate + Finalize first statement (June 2026, 6 invoices, no prior data) | Opening Balance $0.00 (correct — first ever statement). Subtotal $1,311.72 + GST $196.76 = Total $1,508.48, frozen onto `nj_statements` correctly. `nj_statement_id` set on all 6 invoices, packets billed (Dashboard Unbilled $1,188.81 → $900.68) |
| Record Payment: tick INV-0004 ($412.50) + INV-0005 ($470.00) = $882.50, amount received $807.59 | Live credit-note preview updated correctly to $74.91 as ticked. On confirm: both invoices got `paid_date`/`paid_via_payment_id` set, one credit note created (`total: 74.91`, subtotal/GST split correctly at 15%, `issue_date` same day as payment, `source_payment_id` set) |
| Build July 2026 statement (after the payment) | **Opening Balance $625.98** — recomputed live from the 4 still-unpaid invoices from June, not copied from the June statement's stored total. New lines: 4 new real invoices ($1,071.70) + credit note (−$74.91) + payment (−$807.59) = Total $189.20. **Closing Balance $815.18** = Opening + Total, verified exact |
| Void the payment | Invoices reverted to unpaid (`paid_date`/`paid_via_payment_id` cleared), credit note voided, live balance back to $1,508.48 exactly |
| Void the finalized statement | Status → `void`, all 6 invoices released (`nj_statement_id` → null), packets reverted to unbilled (`gabby_billed: false`, `status_id`: New), live balance → $0 (nothing "presented" anymore) |
| Regression: Direct/Alexandra/Queenstown Run Billing Step 1 | Renders correctly, NJ still excluded from retailer dropdown, no console errors |

**Real bug found and fixed during this session (not a code bug — a Supabase config gotcha):** `nj_payments` had RLS enabled with zero policies (silent 403 on every insert) despite the migration script including `DISABLE ROW LEVEL SECURITY` — the disable statement was in a batch that hadn't fully executed yet when first tested. Root-caused via `SELECT relname, relrowsecurity FROM pg_class` + `SELECT * FROM pg_policies` (ground truth, not assumption). Also discovered mid-investigation: `PROJECT.md` incorrectly claimed `packets`/`tax_invoices` had RLS disabled — they actually have RLS enabled with a working `"Authenticated staff access"` policy. Fixed by adding the same policy to `nj_payments` rather than disabling RLS on it, and corrected the stale doc claim (see `PROJECT.md`'s Authentication → Security note).

**Gabby-tested since:** the Admin "Record Payment" modal has since been exercised directly through the real UI multiple times against real dev data (the June/July reconciliation covered in `PROJECT.md`'s "Nationwide Jewellers — Statement" section), including catching two real issues that got fixed in the same pass: an RLS gap on `nj_payments`, and the Month selector allowing an already-finalized period to be reopened (fixed via `njMonthOptions()`/`njNextOpenMonth()`).

*(The `nj_statements.statement_date` and `shipping_runs.shipping_cost_billed` migrations from the previous session are long since applied in dev — no longer a pre-requisite worth calling out here.)*

---

## Entry point

Landing screen is keyed off the G/P toggle — always exactly 2 options, not 3. Gabby sees "Direct" + "Nationwide"; Paula sees "Direct - Paula" + "Nationwide - Paula" (same underlying screens, relabeled).

| Step | Status | Notes |
|---|---|---|
| Nav "Billing" click → landing screen (2 options, toggle-dependent) | Built, untested | Gabby: found the earlier 3-option version "too messy", replaced with toggle-based 2-option layout |
| Dashboard "Run Billing" button → landing screen | Built, untested | |
| Landing card visual style | Not built | Gabby wants this to match the Reports page's card layout — new design system not yet applied here; she'll give styling instructions separately |

## Flow 1 — Direct (Alexandra, Queenstown, Direct — every retailer except Nationwide)

| Step | Status | Notes |
|---|---|---|
| Landing → "Direct" / "Direct - Paula" → Step 1 | Built, untested | |
| Step 1: NJ absent from retailer dropdown | Built, untested | |
| Step 1: item table excludes NJ packets even before a retailer is picked | Built, untested | Bug found in testing: table showed all unbilled items unfiltered (incl. NJ packets, displayed under their sub-customer name e.g. "JDs", "Van de Waters") until a specific retailer was selected. Fixed in `getBillingItems()` — NJ is now excluded from the pool unconditionally unless the filter explicitly targets NJ (the locked Nationwide - Paula case) |
| Step 1: date range filter + item selection | Built, untested | Pre-existing, unchanged by rework — needs regression check only |
| Step 2: retailer invoice summary | Built, untested | Pre-existing, unchanged — regression check only |
| Step 3: PDF generation | Built, untested | Pre-existing, unchanged — regression check only |
| Step 4: confirm + mark billed | Built, untested | Pre-existing, unchanged — regression check only |

## Flow 2 — Nationwide (Gabby bills Nationwide)

| Step | Status | Notes |
|---|---|---|
| Prerequisite: Shipping → Create Shipment (NJ sub-customer) → Print Tax Invoice | Claude-tested | Verified last session; not yet Gabby-tested |
| Landing → "Nationwide" → Statement Builder directly (no packet table shown) | Built, untested | Core fix this rework is for |
| Landing "Nationwide" resumes an existing draft statement instead of showing "Nothing eligible" | Built, untested | Bug found in testing: INV-0008 (Eversons $167) and INV-0009 (GMW Jewellery $328) existed correctly but were already attached to a leftover draft (`mrbho25clg4wy`) from last session's testing — a fresh click into "Nationwide" never checked for an existing draft, so they looked invisible. Fixed: landing now looks up `S.njStatements.find(st=>st.status==='draft')` and resumes it if found |
| Statement Builder: tax invoice / credit / brought-forward lines listed correctly | Claude-tested | Verified last session; not yet Gabby-tested |
| Statement Builder: packet expander per invoice row | Built, untested | Chevron sits next to the "Invoice" label in the Type column (not a separate leading column, per Gabby's feedback — avoids two left-hand interactive elements alongside the checkbox) |
| Save Draft | Claude-tested | Verified last session; not yet Gabby-tested |
| Generate Statement (was Preview) — sequential flow, must generate before Finalize is reachable | Built, untested | Reworked per Gabby's feedback: Finalize is no longer a standalone button — clicking Generate Statement saves + opens the print preview, then the footer's primary button becomes "Review & Finalize" (opens a modal with Reprint/Void — Start Over/Finalize). Any checkbox change after generating resets back to requiring regeneration. Also fixes a real popup-blocked crash ("Cannot read properties of null (reading 'document')") — `window.open()` was being called after an `await`, which strips the browser's user-gesture context; now opened synchronously before the async save |
| Void — Start Over (new) | Built, untested | Available from the review modal for the in-progress statement, works pre- or post-Finalize (reuses `voidNJStatement()`, which already handled draft-status statements correctly, just had no UI entry point before) |
| Finalize (now inside the review modal, not standalone) | Built, untested | |
| NJ Statement History: list, edit draft, reprint final | Claude-tested | Verified last session; not yet Gabby-tested |
| "View Statement History" link relocated onto landing screen | Built, untested | |
| Admin → NJ Statement Reconciliation → Mark as Paid (credit note + brought-forward cascade) | Claude-tested | Verified last session; not yet Gabby-tested |
| Admin → Void | Claude-tested | Verified last session; not yet Gabby-tested |

## Statement formatting rework (per reference PDF Gabby provided)

| Step | Status | Notes |
|---|---|---|
| Month selector on builder screen | Superseded | Originally defaulted to "previous calendar month"; now defaults to `njNextOpenMonth()` (the month right after the most recently finalized statement) and only ever lists that one month — see the redesign section at the top of this doc |
| Eligibility cutoff at month-end (invoices/credits dated after are excluded, wait for next statement) | Gabby-tested | `njLinePool()` filters invoice/credit/payment lines against `njMonthEndDate(b.month)` — unchanged concept, still correct under the redesign |
| Filename / print title → "PGL Appraisals Statement 31 Jul 2026" style | Gabby-tested | Set via `win.document.title`; browser's "Save as PDF" in the print dialog uses this as the suggested filename |
| "Statement Period" → "Statement Date" (single month-end date) | Gabby-tested | |
| Columns: Issued Date, Invoice No, Description, Total Amount, Total Paid, Balance Due | Gabby-tested | Balance Due is a running total starting from the frozen Opening Balance, not zero (see redesign section) |
| Bottom summary: Subtotal (excl GST) / GST / Total Debits / Total Credits / Current / 30/60/90 days / Balance due | Gabby-tested | Reworked twice more since first built — see the redesign section and the two follow-up formatting fixes below for the current, correct shape |
| Credit note reference shows a date range instead of a real credit note number | Not built | Still deferred — needs proper numbering on `nj_credit_notes` alongside full invoice-style credit note formatting |
| "Generated" date removed from meta-grid (redundant with Statement Date) | Gabby-tested | |
| GST Number row in meta-grid | Gabby-tested | `PGL_GST_NUMBER` (near `PGL_LOGO_B64`, top of file) set to 030-949-348 |
| Payment Details footer (bank account) | Gabby-tested | Plain — no remittance tear-off/address, per Gabby's clarification. `PGL_BANK_ACCOUNT_NAME`/`PGL_BANK_ACCOUNT_NUMBER` constants (near `PGL_LOGO_B64`) currently "Coco Solo" / "04-2021-0403908-67" — confirmed by Gabby as the real account despite the name not matching "PGL Appraisals" shown elsewhere |

*(The payment-sweep/brought-forward line types, `sweptElsewhere()`, and the recursive Mark-as-Paid cascade this section used to document are gone entirely under the redesign — including the double-counted-payment bug and its bad-data statement, which was voided during the redesign's own testing. See the redesign section at the top of this doc and `PROJECT.md` for the current model.)*

## Flow 3 — Nationwide - Paula (Paula invoices Gabby for her NJ share)

| Step | Status | Notes |
|---|---|---|
| Landing → "Nationwide - Paula" → locked item picker (no dropdown) | Built, untested | |
| Item picker shows only NJ items where paula_pct > 0 | Built, untested | Reuses existing `getBillingItems()` logic |
| Step 2: summary reads "Invoice to: Gabby Lovering" | Built, untested | Pre-existing logic (`isCombinedPaula`), needs re-verification via new entry point |
| Step 2: sub-customer shows resolved name, not raw ID | Fixed | Bug found in testing: `bySubCustomer` keys on raw `sub_customer_id`, and the row label printed that raw key directly (e.g. "Valuations - 4") instead of `scName(sc)`. This is also most of why the NJ view looked so different/broken next to Standard billing's clean rows |
| Step 2: shipping removed from Paula's invoice entirely | Fixed | Paula never bills Gabby for shipping (Gabby bears that cost and bills Nationwide for it directly via the NJ Statement). Both the per-sub-customer and total shipping lines were showing for Paula; now gated off via `paulaExcludesShipping`, scoped narrowly so Gabby's own view of this screen and every non-NJ retailer are unaffected. `shippingExGST` itself is zeroed (not just hidden), so the Total also correctly excludes it, not just the line item |
| Step 2: packet count + expandable packet list per sub-customer | Built, untested | "Valuations - Eversons - ... (3 packets)" with a chevron (same interaction as the NJ Statement builder's invoice expander) revealing ref/surname/item count/amount per packet, for reconciliation |
| Step 3 PDF: shipping removed from Paula's invoice | Fixed | Same `paulaExcludesShipping` gate applied to `generatePDFContent()` — per-run "Shipping" line and the Shipping Subtotal in SUMMARY are both omitted for Paula. The PDF's per-item sub-customer name was already correct (`scName()`), only the on-screen summary had the raw-ID bug |
| Step 4: confirm + mark billed | Built, untested | Pre-existing, regression check only |

## Cross-cutting bug found in testing: GST using the wrong user's registration

| Step | Status | Notes |
|---|---|---|
| `printInvoice()` (the actual NJ Tax Invoice) used `getCurrentUser()` for GST | Fixed | Produced a 0%-GST tax invoice whenever the G/P toggle was on Paula (not GST-registered) at print time, regardless of who's actually invoicing (always Gabby for NJ tax invoices). Now always looks up Gabby specifically, matching `njTaxInvoiceAmount()`'s existing correct pattern. See CLAUDE.md rule 22 |
| Shipment modal's live GST preview (before printing) | Fixed | Same fix, scoped to `isNJ` only — non-NJ packing slip preview unchanged |
| `renderTaxInvoices()` (Admin tax invoice list) | Fixed | Same fix — always Gabby |
| Shipping Audit "Cost" column | Fixed | Same fix — under the unified billing model every retailer's cost reflects Gabby's GST, not whichever toggle is viewing the report |

## Cross-cutting bug found in testing: manual toggle desyncing an NJ packet from its statement

Root cause of "Invoice 004 (Eversons, $412.50) shows unbilled in Records despite being on a paid statement": the packet's `gabby_billed` was manually reset (via the "New" status lozenge or the "Gabby: Billed" toggle button) at some point during testing, desyncing it from the real statement that already billed it.

| Step | Status | Notes |
|---|---|---|
| **Action needed:** manually re-mark the Eversons packet (INV-0004, $412.50) as Gabby: Billed | **Pending — Gabby to do this before the lock below ships**, since the toggle becomes unclickable for NJ packets afterward | |
| Lock `gabby_billed` on NJ packets to only change via finalize/void — both directions | Fixed | "Gabby: Billed" toggle button now disabled for NJ packets regardless of current state (with a tooltip explaining why), and the "New" status lozenge no longer resets `gabby_billed` for NJ packets (still resets Paula's). See CLAUDE.md rule 23. Does not retroactively fix packets already desynced before this shipped |

## NJ shipping markup (10%, to cover Nationwide's 8.5% commission on shipping too)

`shipping_runs.shipping_cost` stays the raw, untouched fulfilment-partner charge (for the Fulfilment Summary "pay them this" report). A new `shipping_cost_billed` column holds the frozen, GST-inclusive, marked-up figure (`shipping_cost × 1.10` for NJ, computed once at ship time) that's actually invoiced — see PROJECT.md's `shipping_runs` entry for the full rationale.

| Step | Status | Notes |
|---|---|---|
| Shipment creation stores both `shipping_cost` (raw) and `shipping_cost_billed` (NJ: ×1.10, rounded to cents; non-NJ: same as raw) | Built, untested | |
| Create-Shipment modal's live GST preview matches the marked-up figure | Built, untested | Previously previewed off the raw input; now matches what actually gets stored/invoiced |
| Shipping row labelled "Shipping +10%" for NJ (not just a silent recompute) | Built, untested | Non-NJ (packing slip) still reads plain "Shipping" |

## Print bug: logo missing on first print of Tax Invoice/Statement

Root cause: `win.print()` was called synchronously right after `document.write()`/`document.close()`, racing ahead of the base64 logo image finishing decode/paint — worked on the second attempt only because the image was already decoded by then. Fixed in all three print functions (`printStatement()`, `printInvoice()`, `printPackingSlip()`) by moving the print trigger into an inline `<script>window.onload=...</script>` inside the popup's own HTML, so it only fires once the window (and its images) have actually finished loading. Packing slips have no logo today but got the same fix for consistency.

| Step | Status | Notes |
|---|---|---|
| Tax Invoice prints with logo on first attempt | Fixed | |
| Statement prints with logo on first attempt | Fixed | |
| Packing slip print trigger hardened too (no logo currently, precautionary) | Fixed | |
| **Regression introduced by the above fix, then fixed:** whole app broke on refresh (blank/stuck on sign-in never loading, `Uncaught SyntaxError: Unexpected end of input`, broken image URL, frame-loading security error) | Fixed | The inline `<script>...</script>` I added inside each print template literal contained a literal `</script>` — HTML parsers scan for that exact character sequence to end a script block regardless of JS string/template-literal context, so it silently closed the *entire app's* main `<script>` tag early, turning everything after it into inert page text (explaining the cascading image-URL and frame errors). Fixed by escaping it as `<\/script>` (the standard technique — `\/` is a no-op escape in JS so the string value is unchanged, but the HTML tokenizer no longer recognizes it as a closing tag). Verified: app reloads clean with zero console errors |
| `printInvoice()` (actual Tax Invoice) uses the billed figure | Built, untested | Both the initial print and in-modal reprint (before the run exists in the DB) compute it inline via `njBilledShippingCost()`; reprints from Tax Invoices admin and Shipping Audit read the stored `shipping_cost_billed` |
| NJ Statement (`njTaxInvoiceAmount()`) uses the billed figure | Built, untested | Flows through to the Statement Builder and printed Statement automatically |
| `renderTaxInvoices()` (Admin list) and Shipping Audit "Cost" column use the billed figure for NJ rows | Built, untested | Non-NJ rows unaffected |
| Gabby's fallback view of the old billing wizard (`getShippingForBilling()`, `generatePDFContent()`) uses the billed figure for NJ | Built, untested | Paula's view already shows $0 shipping (previous fix) so this doesn't apply to her |
| Fulfilment Summary report still shows the raw, un-marked-up cost | Confirmed unchanged | This is the "what we owe the fulfilment partner" report — correctly untouched |
| Existing shipping_runs shipped before this change | N/A by design | `shipping_cost_billed` will be `null` for them; every read falls back to raw `shipping_cost` (`??`) rather than guessing a retroactive markup on already-invoiced amounts |

## Records screen: Retailer column shows sub-customer for NJ

| Step | Status | Notes |
|---|---|---|
| Records "Retailer" column shows resolved sub-customer name for NJ packets | Fixed | Previously every NJ packet showed the same "Nationwide Jewellers" text, making individual packets impossible to tell apart. Now `scName(r.sub_customer_id)||retailerName(r.retailer_id)` — same fallback pattern as the Billing item table. Falls through automatically to Direct too if it's ever given sub-customers. Dashboard's Unbilled Packets table already had a separate Sub-customer column and was left untouched |

## Known open issues (explicitly out of scope for this rework)

- Paula discount-leak in `buildInvoiceSummary()` — her NJ share is under-calculated by the discount %.
- NJ Statement Bill-To address uses Nationwide's AU head-office address — unconfirmed for NZ-issued statements.
- `isRetailerCombined()` dead-code cleanup — cosmetic.
- Credit notes need a proper credit note number (like `INV-XXXX` for tax invoices) instead of a date-range reference.

*(The old "voiding an already-Paid statement whose credit note is used elsewhere" issue no longer applies — the payment-entity redesign removed the cross-statement credit note chain that caused it. Voiding a payment or a statement is now independent of the other; see `PROJECT.md`.)*
