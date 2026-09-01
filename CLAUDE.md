# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## CRITICAL: Branch Discipline

**Always work on `dev` — NEVER commit to `main` directly.**

- All development commits go to `dev`
- `main` is production-only — updated only when merging `dev` for a release
- A pre-commit hook enforces this: any commit attempt on `main` will be blocked with an error
- If you find yourself on `main`, stop and run `git checkout dev` before making any changes

## CRITICAL: Dev/Prod File Discipline

**Always edit `AppraisalTracker-dev.html` — NEVER `index.html` during development.**

| File | Purpose | Supabase |
|---|---|---|
| `AppraisalTracker-dev.html` | Active dev file — edit this | Dev DB |
| `index.html` | Prod file — only updated when committing | Prod DB |

Rules:
- All code changes go into `AppraisalTracker-dev.html` first
- **Never generate the dev file from `index.html`** if dev is ahead of prod — overwriting it destroys work. Safe to regenerate only when they are confirmed in sync (e.g. start of session after a full merge)
- To regenerate dev from prod: `sed` to swap only `SB_URL`, `SB_KEY`, and `<title>` — nothing else
- When the user approves changes for commit, copy dev to prod the same way
- The preview server at port 8081 serves the whole directory — always navigate to `/AppraisalTracker-dev.html` to test

## Overview

Billing tracker for jewellery appraisals. Paula and Gabby invoice jewellery retailers independently based on per-job cost split percentages. Single HTML file + external stylesheet (`styles.css`), vanilla JS, Supabase (PostgreSQL via REST, no SDK), hosted on GitHub Pages.

Full project reference: `PROJECT.md` — read for DB schema, business rules, and design system details.
Refreshing the dev DB from prod: `DEV-DB-REFRESH.md` — read before attempting it; there are two traps that waste hours.

## Architecture

**Rendering:** Custom `h(tag, attrs, ...children)` helper creates DOM elements imperatively. Every state change calls `render()`, which wipes `#app` and rebuilds the entire DOM. No diffing.

**State:** Single global `S` object. Key fields:
- `S.view`, `S.editId`, `S.user` (`'gabby'` | `'paula'`), `S.currentUser`
- `S.packets`, `S.allPacketItems`, `S.retailers`, `S.jobTypes`, `S.billingStatuses`, `S.users`
- `S.subCustomers` — full rows from `sub_customers` table (with address fields)
- `S.shippingRuns` — full rows from `shipping_runs` table
- `S.shippingFilters` `{retailerId, subCustomer}`, `S.shippingSelected` (Set of packet ids)
- `S.shippingReport`, `S.fulfilmentReport` — filter state `{dateRange, dateFrom, dateTo}`
- `S.billing`, `S.billingRuns`, `S.recFilters`, `S.editItems`

**Backend:** Supabase via direct REST — `sbAll`, `sbInsert`, `sbUpdate`, `sbDelete`, `sbUpsert`, `fetchPacketItems(id)`.

**Layout:** Sidenav (220px) + topbar (90px) + main content area, all floating on a white canvas with 8px padding.

## renderForm() Structure

`renderForm(packet)` is the Work Packet form (~550 lines). Sections and helpers inside it:

```
// -- PACKET HEADER STATE (hdr) --   mutable fields: dateISO, retailerId, customerRef, refSuffix, surname, subCustomer
// -- ITEM STATE --                   formItems[] — pre-loaded from S.editItems (edit) or blank (new)
// -- FIELD ERROR HELPERS --
  clearFieldError(input, errorEl)     removes .error class, hides message
  showFieldError(input, errorEl, msg) adds .error class, sets message, shows it
// -- PACKET DETAILS SECTION --       billing status, date, retailer, ref, sub-customer, surname
  syncCustomerRef()                   writes hdr.customerRef from current inputs (NJ = free text, others = prefix+suffix)
  rebuildCustomerRefInput()           swaps refWrap between free-text (NJ) and prefix+suffix (standard)
  rebuildSubCustomerSelect()          builds/rebuilds NJ sub-customer dropdown
// -- ITEMS SECTION --
  buildItemCard(item, index)          builds an item card DOM node
  buildSplitSlider(item)              builds Paula/Gabby split slider (called from buildItemCard)
  rebuildItemsStack()                 clears and re-renders all item cards
// -- SAVE LOGIC --
  validateForm()                      returns {valid, firstError} — shows errors inline, never calls render()/toast()
  doSave(saveAndNew)                  validates then calls savePacket/updatePacket
```

## Bug Prevention Rules (read before every edit)

1. **Edit the dev file** — `AppraisalTracker-dev.html`, not `index.html`
2. **Never `render()` or `toast()` inside a form** — wipes draft state. Use `showToast()` + `renderAsync()` instead
3. **Non-critical tables** (`users`, `packet_items`, `billing_runs`, `sub_customers`, `shipping_runs`) must each be in their own `try/catch` — a failure must not block boot
4. **`items` has no `id` column** — sort with `&order=display_order.asc`, never `id.asc`
5. **No non-ASCII characters in JS** — causes SyntaxError/blank screen
6. **Never use `||` for 0-valid numeric defaults** — use `!= null` (e.g. `row.paula_pct != null ? row.paula_pct : 0`)
7. **`stopPropagation()`** on nested buttons/checkboxes inside clickable rows
8. **Verify icon exists in `I` object** before any `ic()` call. `ic()` returns a DOM element — use `el.innerHTML = I.check` (not `ic('check')`) when setting cell content
9. **Never append `&select=*` to `sbAll`** — it already includes `?select=*`; doubling it returns duplicate rows
10. **Auto-select uses `b.initialised` flag**, not `Set.size === 0`
11. **Declaration order** — `const`/`let` are not hoisted; never reference before declaration
12. **Dashboard dollar cards are POST-TAX, POST-DISCOUNT** — `getDollarStats()` must apply both `discount_pct` and `income_tax_rate`
13. **`replace_all` edits corrupt declaration lines** — never use `replace_all` to rename a variable; the declaration `const foo=foo` will be produced. Rename the declaration and usages separately
14. **Map optimisations are function-local** — `itemsByPacketId`, `packetsByRunId` etc. are built inside render functions. Never reference them from separate top-level functions like `openShipmentModal`
15. **GST applies to everything unless explicitly stated otherwise** — all amounts (appraisals, job costs, etc.) are ex-GST and have GST added at invoice/display time via `getCurrentUser().gst_rate`. The only current exception is `shipping_runs.shipping_cost`, which is stored **GST-inclusive** (divide by 1.15 to get ex-GST). Do not invent new GST exclusions without explicit instruction.
16. **Duplicate declarations cause blank screen** — duplicate `const`/`function` in the same block scope (e.g. after a partial edit inside an `if(step===1){}` block) causes a SyntaxError where `S` is never defined and the app sticks on "Connecting…" with no console error. Always check for pre-existing declarations before adding new ones.
17. **Records page Total column shows raw cost — no discount** — `discount_pct` is never applied to the Records table display. Use raw `i.cost` (no `discountMult`), split by `paula_pct`/`gabrielle_pct` for per-user views. `packetCosts()` applies discount and is for billing calculations only — never use it for display in Records.
18. **Never use text as a PK or FK** — all database IDs must be integers or UUIDs. Text slugs are for display only. Text-based linking breaks silently on rename with no constraint error.
19. **Invoice line items use FULL cost — no discount** — `discount_pct` is an internal billing split between Gabby and Paula; it is never deducted on customer-facing tax invoices. Use raw `i.cost` (no `discountMult`) in `printInvoice`, `getPacketRows`, and the shipping audit cost column. **Exception, left as-is:** `printPackingSlip()` still applies `discountMult` — inconsistent with the principle above, but no Direct retailer currently has a non-zero `discount_pct`, so it's dormant. Fix properly before any Direct retailer gets a discount.
20. **`S.user` (G/P toggle) is not login identity — never conflate them.** `S.user`/`getCurrentUser()` drive business logic (dashboard stats, GST, invoicing) and switch freely when the avatars are clicked. `S.session`/`S.profile` reflect who is actually authenticated and must never change on toggle clicks. This was a real bug: the header briefly showed the toggle's name instead of the logged-in account. See "Authentication" in `PROJECT.md`.
21. **NJ combined-billing eligibility must never depend on `packets.status_id` or the `otherHasNoWork`/0%-shortcut pattern.** `renderBillingStep4()` and the manual billing toggle both auto-flip `status_id` to Billed when the *other* user has 0% on every item — correct for standard retailers (each bills only their split), wrong for NJ (Gabby always owes the retailer the full invoice regardless of her %). The NJ Statement flow's `njLinePool()` sidesteps this by keying "new lines" eligibility off `tax_invoices.nj_statement_id`/`nj_credit_notes.nj_statement_id`/`nj_payments.nj_statement_id` directly, and the live owed-balance off `tax_invoices.paid_date` (via `njCurrentBalance()`) — never off `gabby_billed`, `paula_billed`, `status_id`, or any stored statement-level total. Do not "simplify" this to reuse the shared status logic; that reintroduces the bug. Also: `buildInvoiceSummary()` applies `discount_pct` before splitting by `paula_pct`/`gabrielle_pct`, so Paula's NJ share is currently under-calculated by the discount amount — known, not yet fixed, invisible on every other retailer since they have `discount_pct=0`.
22. **GST on any document that represents Gabby's own invoicing (tax invoices, the NJ Statement, the shipping/tax-invoice audit views) must always use Gabby's `gst_registered`/`gst_rate` specifically — never `getCurrentUser()`.** `getCurrentUser()` reflects the G/P toggle, which can be on Paula (not GST-registered) when someone ships a Nationwide packet or views these screens. Real bug: `printInvoice()` — the actual Tax Invoice sent to NJ sub-customers — used `getCurrentUser()` and silently produced a 0%-GST invoice whenever Paula's toggle was active at print time. Fixed there and in the shipment modal's live preview, `renderTaxInvoices()`, and the Shipping Audit's cost column, all via `S.users.find(u=>u.slug==='gabby')`, matching the pattern `njTaxInvoiceAmount()` already used correctly. This is distinct from `renderBillingStep2()`/`generatePDFContent()`'s own GST line, which is correctly `getCurrentUser()`-based — that screen is Paula-invoices-Gabby or Gabby-invoices-retailer, so it legitimately reflects whichever user is actually invoicing.
23. **`packets.gabby_billed` for a Nationwide packet must only ever change via `finalizeNJStatement()`/`voidNJStatement()` — never manually on the packet's own Edit screen.** Real bug found in testing: someone clicked the "New" status lozenge (which unconditionally reset both `paula_billed` and `gabby_billed` to false) or the "Gabby: Billed" toggle button on an NJ packet whose invoice was already on a paid statement, silently desyncing the packet from the statement that says it's billed. Fixed by locking the "Gabby" billing-flag button in **both** directions for NJ packets (`isNJPacket` check in `renderForm()`) — not just billed→unbilled. A one-directional lock would still let someone manually flip Gabby to Billed with no real statement behind it, creating a packet that looks billed with nothing to void; locking both directions guarantees `gabby_billed=true` on an NJ packet always traces back to a real statement, so voiding that statement is always the correct (and only) undo. The "New" lozenge's reset is now conditional too (`if(!isNJPacket)updateData.gabby_billed=false`) — Paula's flag still resets normally. This does not retroactively fix packets already desynced before this fix shipped; those need a one-off manual correction.
24. **`hdr.subCustomer` must be cleared whenever `renderForm()`'s Retailer dropdown switches to a retailer without sub-customers — never trust it to already be empty.** Real bug found in testing: a packet created (or previously edited) as Nationwide Jewellers with a sub-customer selected, then switched to Alexandra/Queenstown/Direct, kept the stale NJ `sub_customer_id` in memory and saved it onto the packet — invisible on the Edit screen itself (the sub-customer field just hides for non-NJ retailers) but surfacing wherever a packet's retailer name is displayed, since that logic prefers the sub-customer's name whenever one is set. Fixed two ways: the retailer `<select>`'s change handler now does `if(!hasSubCustomers())hdr.subCustomer=null;` so it can't happen again, and `packetRetailerLabel(p)` (near `scName()`) replaced every direct `scName(p.sub_customer_id)||retailerName(p.retailer_id)` call (Records, Billing item table, Dashboard Unbilled) with a version that only trusts `sub_customer_id` when it actually belongs to `p.retailer_id` — so any already-corrupted packets display correctly immediately, without needing a data fix first. Re-saving a corrupted packet (toggle Retailer away and back, then Save) clears the stale value for good.
25. **`shipping_runs.status` (`'draft'`|`'active'`|`'void'`) is set at Print time, not Mark-as-Shipped — the DB row is created once and updated in place, never re-inserted.** `openShipmentModal()`'s Print button calls `ensureDraftPersisted()`, which inserts `shipping_runs` (status `draft`) and, for NJ, `tax_invoices` (status `draft`) immediately, reserving the real invoice/packing-slip number and setting `packets.shipping_run_id` — this is what makes an abandoned print (customer already has the invoice, "Mark as Shipped" never happened) recoverable instead of leaving no record at all. "Mark as Shipped" then **updates** that same row (`ship_date`, `tracking_last4`, `shipping_cost`, `status:'active'`) — never a fresh `sbInsert`. `tax_invoices.issue_date` is set once at draft time and never touched again by Mark-as-Shipped/Complete — it's when the document was actually handed over, not when shipping was later confirmed. A consequence: a packet leaves the Shipping list at **Print** time now, not Mark-as-Shipped (its `shipping_run_id` is already set) — don't "fix" this back, it's what enforces one-invoice-per-packet. Two Admin recovery paths, different semantics — don't conflate them: **Draft Shipments** (`draftShipmentsCard()`) is for an abandoned *draft* — Complete (`completeDraftShipment()`, same pattern as Mark-as-Shipped, shipping cost re-editable since the fulfilment partner's real charge may differ) or Delete (`deleteDraftShipment()`, hard-deletes — a draft never represented a real completed event). **Void a Completed Shipment** (`completedShipmentLookupCard()`/`voidCompletedShipment()`) is for a real, *active* shipment that needs undoing — **voids, never hard-deletes** (keeps the row as an audit trail, matching `voidNJStatement()`/`voidNJPayment()`), and refuses rather than clearing when the invoice is on an NJ statement, already paid, or any linked packet is already billed (`gabby_billed`/`paula_billed`) — see rule 23, never clear `gabby_billed` directly here either. Any report/list that reads `S.shippingRuns`/`S.taxInvoices` (Tax Invoices report, Shipping Audit) must show a status label instead of a Reprint action, and exclude `draft`/`void` rows from money totals — `filterShippingRuns()` has no status filter at all, so a new list built on it needs its own guard.

## Shipping & Invoicing

**`getShippingForBilling(retailerId)`** — finds shipping runs for a retailer within the current billing filter date range. Does NOT filter by selected packet IDs (Direct retailer packets may not appear in the user's selection even when shipped). Returns:
```js
{ total, totalExGST, bySubCustomer, bySubCustomerExGST, bySubCustomerRunCount, runs, runCount, dateLabel }
```

**`nextInvoiceNumber()`** — scans `S.shippingRuns` for existing `INV-XXXX` numbers, returns next padded string.

**`scName(id)`** — resolves a `sub_customers.id` value to a display name. Always use this for display; never use the denormalized `sub_customer_name` field for display logic.

**`openShipmentModal(filteredPackets)`** — two-step modal. Step 1: packet table + shipping cost input (default $10, stored GST-inclusive) → Print persists a draft shipment (see rule 25). Step 2: date + tracking → Mark as Shipped completes that same draft. NJ sub-customers get "Print Invoice" instead of "Print Packing Slip".

**Step 1 modal summary format:** packet rows at full cost (no discount) → Shipping (net, input÷1.15) → Subtotal → GST (if user is GST-registered) → Total. The shipping input is gross (GST-inclusive); only shipping is divided by 1.15, not appraisals.

**Tax invoice (NJ only) and packing slip (Direct):** Title "TAX INVOICE" / "Packing Slip". Tax invoice: To = sub-customer + address, From = PGL Appraisals 34 Tarbert Street Alexandra 9320. Both use the same itemized table structure — one header row per work packet (ref — surname, blank Qty/Unit price/Amount), then one row per item underneath (Description = `Item — Job Type`, Qty 1, Unit price/Amount = the item's cost) — added per Nationwide's request so sub-customers can pass on the per-item cost, not just a packet total. Built directly from `packets`/`S.allPacketItems` in both `printInvoice()`/`printPackingSlip()`, deliberately separate from the `rows` aggregate that still drives the Subtotal/GST/Total footer math — don't merge them back into one loop, the footer must stay unaffected by how the rows render. GST on full subtotal (tax invoice only). `printInvoice()` — do NOT apply `discountMult` to row amounts (rule 19). Logo (`assets/images/PGL-FULL-LOGO.png`) embedded as **base64 data URI** — the popup window has no base URL so relative paths don't resolve. Print headers/footers suppressed via `@page { margin: 0 }` in the popup's CSS — `printStatement()` (NJ Statement) is the one exception, using `@page { margin: 20mm }` instead since it's the only one of these that regularly spans multiple pages; see "NJ Statement" below.

**Billing Step 2 modal — NJ format:** One "Valuations - [sub-customer] - [date]" line + one "Shipping - [sub-customer] - [date] (N)" line per sub-customer. No job-type breakdown. Subtotal → discount → shipping total (ex-GST) → GST → Total.

**PDF detailed report — NJ:** Groups items by shipping run. Each run labelled `Invoice: INV-XXXX YYYY-MM-DD (tracking ...XXXX)`. Falls back to `Shipment:` for runs without an invoice number.

## NJ Statement (Gabby's actual NJ billing path)

Full detail in `PROJECT.md` under "Nationwide Jewellers — Statement, Credit Notes & Reconciliation". Quick reference:

- Reached via Run Billing Step 1 → select Nationwide Jewellers → Start → **chooser screen** (`S.billing.step==='nj'`, `renderNJChooser()`), not straight to Step 2. "Generate NJ Statement" → `S.view='njStatement'` (new, isolated code). "Continue to invoice wizard" → unchanged Step 2–4 (Paula's path, also Gabby's fallback).
- Tables: `nj_statements` (draft/final/void, frozen `opening_balance`/`aging_current`/`aging_30`/`aging_60`/`aging_90`), `nj_statement_lines` (frozen new-lines snapshot — never recompute from live data on reprint), `nj_credit_notes` (`source_payment_id` FK), `nj_payments` (the real payment entity). Columns `tax_invoices.nj_statement_id`/`paid_date`/`paid_via_payment_id`.
- **Payment is tracked per-invoice, not per-statement — redesigned 2026-07.** `recordNJPayment()` (Admin → NJ Payments → Record Payment) sets `paid_date`/`paid_via_payment_id` on whichever invoices are ticked (any period) and auto-generates a credit note for the ticked-total-minus-payment difference, dated the same day. **Finalize ≠ Paid.** Finalize (in the Billing wizard) only bills the packets under a statement's invoice lines — it never touches payment. Never reintroduce a statement-level "Mark as Paid"/`markNJStatementPaid()` — that was the old, removed design.
- The live "currently owed" balance is **always** `njCurrentBalance(asOfDateISO)` — a fresh sum over `tax_invoices` unpaid **as of a given date** (`!paid_date || paid_date > asOf`, not just `paid_date IS NULL`) — the `asOf` awareness matters: it's what lets Opening Balance answer "what was owed at the start of this period" without a payment recorded *during* the period silently double-subtracting itself. Never a stored statement total read back in as another statement's input. This is the actual fix for the original bug (a wrong stored total silently poisoning every later statement that trusted it via `brought_forward`/`payment` line types — deleted, do not resurrect).
- **A statement can only ever be built for one specific month: `njNextOpenMonth()`** — the month right after the most recently finalized statement. `njMonthOptions()` returns only that single month (no historical dropdown) — a finalized period can never be reopened. Without this guardrail, re-selecting an already-finalized month recomputes Opening Balance against a cutoff that's no longer the right question to ask (real bug found in testing — looked like a stale/wrong balance, was actually a UI gap letting a done period be rebuilt).
- Void lives in Admin for both entities — `voidNJStatement()` (`njReconciliationCard()`, releases a statement's lines + reverts packet billing) and `voidNJPayment()` (`njPaymentsCard()`, un-pays whichever invoices that payment settled, voids its credit note) — not on the Billing-side History screen. Deliberate split between routine build/send actions and back-office reconciliation.
- `printStatement()` reuses `printInvoice()`'s popup/base64-logo pattern via the shared `PGL_LOGO_B64` constant (declared near `gid()`) — don't re-embed the logo inline again if you touch either function.
- **`printStatement()`'s print CSS uses `@page { margin: 20mm }`, not `margin: 0`.** Every other print popup (`printInvoice`/`printPackingSlip`) uses `@page{margin:0}` + `body{padding:20mm}` in print media, which only applies that padding once at the very start of the page flow — fine for a document that's almost always one page, but it meant a Statement that overflowed to page 2 started flush at the top with no margin (real bug, found via a printed PDF). `@page` margin re-applies on every physical page, which is the correct fix for a genuinely multi-page document — the trade-off is it reopens room Chrome's own print-dialog header/footer could use if that browser setting happens to be on (harmless if it's off, which is Chrome's default). Don't "fix" this back to match the other two popups; they're multi-page-safe now.

## Authentication

Internal staff tool — **sign-in only, no public sign-up**. Accounts are created directly in the Supabase dashboard (Authentication > Users), not through the app. Full detail in `PROJECT.md` under "Authentication"; quick reference for editing this code:

- `renderAuthPage()` covers sign-in and forgot-password (`S.authView`: `'login'` | `'forgotPassword'`). Do not add a sign-up form back in without being asked.
- `renderSetPasswordPage()` is a separate full-page override for invite-acceptance and password-reset landings (`S.authMode==='setPassword'`, reason `'invite'` or `'recovery'`) — it takes priority over both the login page and the app shell in `render()`. Sending invites themselves stays admin-only in the Supabase dashboard (needs the service-role key, which never belongs in this client-side app) — the app only handles the "set your password" landing.
- `render()` gates on `S.authMode` first, then `S.session` — if you add a new view, it's automatically protected; there's no per-route auth check to remember.
- Sign-in and forgot-password errors always show a generic message ("Invalid email or password" / "If an account exists...") — never surface the raw Supabase error there, it can leak whether an account exists or is unconfirmed. `renderSetPasswordPage()` is the one exception where a specific error is fine (the link is already tied to one account, so there's no enumeration risk).
- `onAuthStateChange` calls `render()` for `SIGNED_IN`/`SIGNED_OUT`/`PASSWORD_RECOVERY`. `TOKEN_REFRESHED`/`USER_UPDATED` update `S.session` silently — **do not add a `render()` call there**, it would wipe an in-progress Work Packet form draft on a background token refresh.
- **`SIGNED_IN` can refire on tab refocus, not just a genuine new login** — supabase-js re-validates the session when the tab regains focus/visibility and can emit `SIGNED_IN` again for the *same* account, not only `TOKEN_REFRESHED`. The handler compares the new session's `user.id` against the previous one (captured before `S.session` is overwritten) and skips the full `loadAll()`+render reload when it's the same user — only a genuinely different account triggers it. Without this, every tab refocus (e.g. switching tabs to copy something) reset `S.ready` and wiped in-progress form drafts. Don't remove this check.
- `hdrs()` sends `S.session.access_token` when signed in, falling back to the anon `SB_KEY` only when signed out. Don't hardcode `SB_KEY` in new fetch calls — always go through `hdrs()`/`sbAll`/etc.
- `S.user` (G/P toggle) is **not** login identity — see rule 20 above. `S.profile` (from `public.profiles`, RLS-protected, one row per logged-in account) is the real identity; it's separate from `S.users` (the Gabby/Paula business rows the toggle switches between).
- `applyAppraiserDefault()` runs once after `loadAll()` on login/session-restore, defaulting `S.user` from `S.profile.appraiser_id`. It never runs on every render, so it won't fight a manual toggle click mid-session.

## Design System & Styling

**In-progress migration** from `styles.css` (legacy) to `style-new.css` (token-based). See `MIGRATION.md` for status per section.

**Stylesheet load order:**
1. `design-system/tokens/tokens-html.css` — plain `:root {}` token variables
2. `design-system/components/html/components.css` — base component classes in `@layer components`
3. `styles.css` — legacy (retire when migration complete)
4. `style-new.css` — migration target; unlayered rules here override both legacy and layered components

**CRITICAL — `styles.css` is legacy. Never read it, never reference it, never diagnose from it.** Fix visual bugs by re-asserting the correct value in `style-new.css`.

**CSS Cascade Rule (CRITICAL):** `@layer components` has *lower* priority than unlayered rules. To fix a visual bug: re-assert the property in `style-new.css` (unlayered, loads last, wins).

**Figma source:** File key `Cc9WVPSYJoQDiSV4LV7Edk`. Raw colour variables in node `842-49172`.

**CRITICAL — OKLCH palette:** Never regenerate from Tailwind defaults — always convert from Figma hex using the precise hex → OKLCH formula.

**Token naming:** Use new design system names — `--color-secondary`, `--color-foreground`, `--color-stone-300`, `--color-gold-400`, `--color-violet-700`, etc. Avoid all legacy names (`--plum`, `--sage`, `--bg-warm`, `--text-sec`, etc.).

**Cache-busting:** Increment `?v=N` on stylesheet links whenever CSS files change during active development.

**Key component classes:** `.label`, `.input` / `.select` (44px height), `.btn-primary` (gold), `.btn-secondary`, `.btn-sm`, `.btn-link`, `.btn-destructive`, `.table`. Form layout: `.form-section`, `.form-grid` (2-col), `.item-card`.

## Pre-Delivery Checklist

- [ ] Edited `AppraisalTracker-dev.html` (not `index.html`)
- [ ] No `render()`/`toast()` inside form validation
- [ ] Non-critical tables in separate `try/catch`
- [ ] No non-ASCII in script block
- [ ] No literal newlines in JS strings
- [ ] No duplicate variable declarations in same scope
- [ ] Numeric defaults use `!= null` not `||`
- [ ] Nested row elements have `stopPropagation`
- [ ] All `ic()` references exist in `I` object
- [ ] No `&select=*` appended to `sbAll` queries
- [ ] Map optimisations not leaked into other function scopes
- [ ] No duplicate `const`/`function` declarations in the same block scope
- [ ] Invoice/packing slip line items use raw `i.cost` — no `discountMult`
- [ ] `S.user` (G/P toggle) not conflated with login identity (`S.session`/`S.profile`)
- [ ] No `render()` added inside `onAuthStateChange` for `TOKEN_REFRESHED`/`USER_UPDATED`
- [ ] NJ Statement/Payment "new lines" eligibility keyed off `nj_statement_id` FKs (`tax_invoices`/`nj_credit_notes`/`nj_payments`), and the owed balance off `tax_invoices.paid_date` via `njCurrentBalance()` — never `status_id`/`gabby_billed`/`paula_billed`, and never a stored statement total read back in as another statement's input
- [ ] GST on tax invoices/NJ Statement/audit views uses Gabby's rate specifically (`S.users.find(u=>u.slug==='gabby')`), never `getCurrentUser()`
- [ ] NJ packet's `gabby_billed` only changes via `finalizeNJStatement()`/`voidNJStatement()` — locked in both directions on the packet's own Edit screen
- [ ] New Supabase tables have their actual RLS state verified after creation, not assumed from intent — `SELECT relname, relrowsecurity FROM pg_class WHERE relname='<table>'`. Don't just add `DISABLE ROW LEVEL SECURITY` and move on: check whether the table should instead get the same `"Authenticated staff access"` policy `packets`/`tax_invoices` use (see `PROJECT.md`'s Authentication section) — that's the better match for anything holding real business/money data. A `CREATE TABLE` + `DISABLE ROW LEVEL SECURITY` in the same script can still leave RLS on with zero policies (403s every request) if the disable didn't actually execute — verify, don't trust the script's intent
- [ ] `hdr.subCustomer` cleared on the Retailer dropdown's change handler whenever the new retailer has no sub-customers — packet retailer display anywhere goes through `packetRetailerLabel(p)`, never a bare `scName(p.sub_customer_id)||retailerName(p.retailer_id)`
- [ ] `shipping_runs`/`tax_invoices` rows created once at Print (draft) and updated, never re-inserted, at Mark-as-Shipped/Complete — `tax_invoices.issue_date` never touched after draft creation
- [ ] Any list/report reading `S.shippingRuns`/`S.taxInvoices` shows a status label (not Reprint) and excludes `draft`/`void` from money totals
- [ ] Tested in browser against dev Supabase before reporting done
