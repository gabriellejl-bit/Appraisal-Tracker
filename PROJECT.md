# Billing Tracker - Project Context

## Purpose
Billing tracker for jewellery appraisal work. Paula and Gabby invoice jewellery retailers separately based on their work split percentage per job.

## URLs
- Live: https://gabriellejl-bit.github.io/Appraisal-Tracker/
- Repo: https://github.com/gabriellejl-bit/Appraisal-Tracker

## Stack
- Frontend: Single HTML file (index.html) + external stylesheet (styles.css) - vanilla JS, no framework
- Database: Supabase (PostgreSQL) via REST API - no SDK, raw fetch
- Hosting: GitHub Pages
- Auth: None yet — user toggle in topbar. Supabase email/password planned.

## Environments

| | Production | Dev |
|---|---|---|
| File | index.html | AppraisalTracker-dev.html (local only) |
| Supabase URL | https://ytmyfarsptkezxkgpcbo.supabase.co | https://xwripwrfqdddfomzfjaq.supabase.co |
| Supabase Key | sb_publishable_2POAMJdA5U1FPSgxzDy1oA_EfCnF6I2 | sb_publishable_FktRKmVGhdS5SzeJ7g6phQ_n9m4iDcm |
| Browser tab | "Billing Tracker" | "Billing Tracker [DEV]" |

Only difference between files: SB_URL, SB_KEY, title tag. Dev is always ahead of or equal to prod.

**Dev/Prod discipline:** Always test in dev first. DB changes: run in dev, verify, then prod. To create dev file: swap SB_URL, SB_KEY, and title tag only.

---

## Database Schema

### users
`id, name, slug (UNIQUE), colour, gst_registered, gst_rate DECIMAL, income_tax_rate DECIMAL, active`
- Gabby: gabby, #5C7A6B, GST registered 15%, income tax 33%
- Paula: paula, #6E4B5E, not GST registered, income tax 17.5%

### billing_statuses (lookup)
`id, name, show_in_dashboard, show_in_reports`
Values: New (1), Hold from Billing (2), Billed (3), Archived (4 — hidden everywhere)
"Billed" is auto-managed only — never set manually.

### retailers (lookup)
`id, name, code INTEGER, discount_pct DECIMAL (default 0), combined_billing BOOLEAN (default false), requires_shipping BOOLEAN (default false)`
- Alexandra (1, code 1) — Jamies Alexandra in PDFs
- Queenstown (2, code 2) — Jamies Queenstown in PDFs
- Nationwide Jewellers (3, code 3, discount 8.5%, combined_billing true, requires_shipping true)
- Direct (4, requires_shipping true)

WARNING: Never append `&select=*` to sbAll calls — sbAll already includes `?select=*`.

### items (lookup)
`name TEXT PK, display_order INTEGER`
WARNING: no id column. Sort: `&order=display_order.asc`

### job_types (lookup)
`id, name, cost DECIMAL, display_order INTEGER`. Sort: `&order=display_order.asc`

### sub_customers
`id, retailer_id FK, name TEXT, display_order INTEGER, address_line1 TEXT, suburb TEXT, city TEXT, postcode TEXT`
NJ sub-customers. Loaded into `S.subCustomers`. Address fields used in tax invoices.

### packets
`id TEXT PK, date TEXT (DD MMM YYYY), retailer_id FK, customer_ref TEXT, sub_customer TEXT (nullable, NJ only), surname TEXT, status_id FK, paula_billed BOOLEAN, gabby_billed BOOLEAN, shipping_run_id FK (nullable), created/modified TEXT`

### packet_items
`id TEXT PK, packet_id FK, item TEXT, job_type_id FK, cost DECIMAL, paula_pct INTEGER, gabrielle_pct INTEGER (sum to 100)`

### shipping_runs
`id TEXT PK, ship_date TEXT, shipping_cost DECIMAL (GST-INCLUSIVE), tracking_last4 TEXT, retailer_id FK, sub_customer_name TEXT (nullable), invoice_number TEXT (nullable, format INV-XXXX, NJ only, denormalized from tax_invoices), packing_slip_number TEXT (nullable, format PS-XXXX, Direct only), created TEXT`

**CRITICAL — shipping_cost is stored GST-inclusive.** Always divide by 1.15 to get ex-GST amount for billing display. `getShippingForBilling()` pre-computes `totalExGST` and `bySubCustomerExGST`.

### tax_invoices
`id TEXT PK, invoice_number TEXT UNIQUE (INV-XXXX format), shipping_run_id FK, issue_date TEXT, retailer_id FK, sub_customer_name TEXT (nullable), status TEXT ('active'|'void'), created TEXT`
NJ tax invoices as first-class entities. One record per NJ shipping run. `invoice_number` is also denormalized onto `shipping_runs` for fast display in the audit. Packets on an invoice are inferred via `packets.shipping_run_id`. Loaded into `S.taxInvoices`. `nextInvoiceNumber()` scans `S.taxInvoices` to find the max INV number.

### billing_runs
`id TEXT PK, run_date TEXT, user_name TEXT (slug), retailer_ids TEXT (csv), packet_ids TEXT (csv), status TEXT, created TEXT`

### retailer_job_type_costs
`retailer_id FK, job_type_id FK, cost DECIMAL`. Currently empty — reserved for future per-retailer pricing.

---

## Key Concepts

**Cost split:** `packetCosts(id)` returns `{total, paula, gabby}`. Applies retailer `discount_pct` before splitting. Formula: `cost * discountMult * userPct%`.

**Dashboard dollar cards:** POST-TAX, POST-DISCOUNT take-home income. `getDollarStats()` applies both `discount_pct` and `income_tax_rate`.

**Per-user billing:** `paula_billed`/`gabby_billed` track independently. When both true (or one user has 0% on all items), status auto-sets to Billed. Never set Billed manually.

**GST:** Conditional per user (`gst_registered` from users table). Gabby: subtotal + GST + Total. Paula: subtotal + Total only. Applied AFTER discount. Rate from `users.gst_rate`.

**Financial year:** 1 April – 31 March (NZ).

**Falsy trap:** Use `!= null` for numeric defaults where 0 is valid. e.g. `row.gabrielle_pct != null ? row.gabrielle_pct : 100`

**Nationwide Jewellers (NJ) — Combined Billing:**
- `combined_billing=true`: Gabby invoices the retailer for FULL job cost + GST. Paula invoices Gabby for her % share.
- Gabby's billing selection includes ALL NJ items (even where `gabrielle_pct=0`). Paula sees only `paula_pct > 0` items.
- Step 2 modal: Gabby → "[Retailer] — All", Paula → "[Retailer] — Invoice Gabby" (subtitle: "Invoice to: Gabby Lovering")
- Invoice summary groups by sub-customer: one "Valuations - [sub-customer] - [date]" line + one "Shipping - [sub-customer] - [date] (N)" line per sub-customer. Then gross subtotal → discount → shipping total (ex-GST) → GST → Total.
- `isRetailerCombined(retailerId)` checks `combined_billing` flag.

**Business rule — one invoice/slip per packet:**
A packet can never appear on more than one invoice or packing slip. The database enforces this structurally (`packets.shipping_run_id` is a single FK), and the shipping view enforces it in the UI by only showing packets where `shipping_run_id IS NULL`. If a packet needs to move to a different run (e.g. error correction), it must first be removed from the existing run (voiding or editing the invoice/slip) before it can be re-shipped. The UI for this is a future todo — see "Invoice edit / void screen" in Planned Features.

**Shipping workflow:**
- Packets for NJ and Direct are shipped in batches. Each batch creates a `shipping_run` record and sets `shipping_run_id` on each packet.
- NJ shipments generate a tax invoice (`INV-XXXX`) printed at ship time. Invoice number stored in `shipping_runs.invoice_number`.
- `getShippingForBilling(retailerId)` — matches runs by retailer + billing filter date range (NOT by selected packet IDs, since Direct packets may not appear in a user's billing selection even when shipped).
- `nextInvoiceNumber()` — scans `S.taxInvoices`, finds max `INV-XXXX`, returns next padded string.

**Tax invoices (NJ sub-customers):**
- Title: "TAX INVOICE". To: sub-customer name + address (from `sub_customers` table). From: PGL Appraisals, 34 Tarbert Street, Alexandra 9320.
- Line items: per-packet row (ref — surname — item count). Shipping shown ex-GST (stored amount ÷ 1.15). GST 15% on full subtotal. Amount due NZD.
- No due date (billed via Nationwide).

**Invoice Groupings (billing PDFs):**
Job types mapped to three billing categories (`INVOICE_GROUPS` constant):
- Valuations — default
- Stock — "Stock Update", "Stock - New"
- Pearl Threading — "Pearl Threading"

**PDF detailed reports — NJ:**
Groups items by shipping run. Each run header: `Invoice: INV-XXXX YYYY-MM-DD (tracking ...XXXX)`. Falls back to `Shipment:` for older runs without an invoice number. Summary: Valuations Subtotal → Shipping Subtotal (ex-GST) → GST → TOTAL.

---

## Nav Structure
Centre: Dashboard · Records · Run Billing ($icon) · Reports · Shipping
Right: [User toggle] [+ New Packet] [Connected dot]
Reports nav active for: reports, billingRunsReport, customerReport.
Shipping nav active for: shipping, shippingReport, fulfilmentReport.

## Views / Screens

### Dashboard
- 3 dollar cards (POST-TAX POST-DISCOUNT): Unbilled / Earned This Week / Earned This Month
- 4 status count cards: New / On Hold / Part Billed / Fully Billed
- Unbilled Packets table (full width, current user only): Date, Ref, Surname, Sub-customer, Retailer, Status, Items, Cost
  - Excludes packets where the current user has 0% on all items (N/A)
  - Excludes effectively-billed packets (100% user billed = fully billed)

### Records
- Filters: Status pills, Retailer, User, Date range, Search, Reset
- Cost column (Total/Paula/Gabby per User filter)
- Shipped column: tick icon if `shipping_run_id` is set
- Whole row clickable to edit. Batch status update + CSV export.

### New / Edit Work Packet
- Sticky header: title + status badge (edit) + Cancel + split Save button
- Edit mode — Billing Status card: workflow lozenges (New/Hold/Archived), billing toggles (Paula/Gabby), delete button
- Packet Details: Date, Retailer + Ref, Surname
  - NJ: free-text ref, required sub-customer dropdown
  - If shipped: "Shipped: See shipping details" link → inline expandable panel showing packing slip details
- Items (up to 3): Item + Job Type, Cost, Split slider

### Run Billing (4 steps)
1. Selection: date filter (default last month), status filter. Auto-selects eligible items via `b.initialised` flag.
2. Retailer modal loop: invoice summary (copy/paste) + items table. GST conditional. NJ groups by sub-customer.
3. PDFs: jsPDF A4, Courier monospace. NJ groups by shipping run/invoice.
4. Confirm: sets per-user billed flags, saves billing run.

### Reports
Landing page → Billing Runs, Customer Report.

### Billing Runs
Billing run history. Regenerate PDFs. Delete run.

### Customer Report
Filter: date range + retailer. Groups by retailer, lists items per customer. Download PDF.

### Shipping
- Filter: retailer/sub-customer. Lists unshipped packets with checkboxes.
- "Create Shipment" CTA → two-step modal: (1) packet table + shipping cost → Print Invoice (NJ) or Print Packing Slip, (2) ship date + tracking → Mark as Shipped.

### Shipping Audit
Expandable per-run rows. Columns: Date, Retailer/Sub-customer, Invoice, Tracking, Packets, Cost. Shows `INV-XXXX` for NJ runs.

### Fulfilment Summary
Flat list of all shipping runs with packet counts and costs.

---

## Code Conventions

**State (S):** See CLAUDE.md for full field list.

**Render:** `render()` = full DOM rebuild. `renderAsync()` = pre-fetches edit data first. Never call from inside a form.

**Toast:** `toast()` calls `render()` — never inside forms. Use `showToast()` (direct DOM inject, safe anywhere).

**Key helpers:**
- `getCurrentUser()` — full user row, call once per function
- `getDollarStats()` — `{unbilled, earnedWeek, earnedMonth}` POST-TAX, POST-DISCOUNT
- `packetCosts(id)` — applies retailer `discount_pct`, returns `{total, paula, gabby}`
- `packetBillingLabel(pkt)`, `userHasBilled(pkt)`, `userHasNoWork(pktId)`
- `getBillingItems()`, `isRetailerCombined(retailerId)`, `invoiceGroup(jtName)`
- `buildInvoiceSummary(items, retailerId)` — returns `{byJobType, bySubCustomer, subtotal, gst, total, discountPct, isNJRetailer, isCombined, isCombinedGabby, isCombinedPaula}`
- `getShippingForBilling(retailerId)` — returns `{total, totalExGST, bySubCustomer, bySubCustomerExGST, bySubCustomerRunCount, runs, runCount, dateLabel}`
- `nextInvoiceNumber()` — returns next `INV-XXXX` string
- `generatePDFContent(retailerId)` — text lines for detailed billing PDF
- `renderBreadcrumb(section)`, `retailerName(id)`, `statusName(id)`, `fmtMoney(n)`, `fmtD(d)`, `getDateRange(key)`

**IDs:** `Date.now().toString(36) + Math.random().toString(36).slice(2,7)` via `gid()`

---

## Workflow
1. Build/test in dev file against dev Supabase
2. Once tested, copy to index.html swapping only SB_URL, SB_KEY, title — push to `dev` branch on GitHub
3. Merge `dev` → `main` for production release
4. GitHub Pages deploys ~2 min from `main`
5. DB changes: dev SQL first, verify, then prod

---

## Admin Section (planned)

A restricted-access admin area for complex operations not safe to expose in the main UI.

**Shipping Runs Admin:**
- View all shipping runs with full detail
- Add or remove individual packets from a run (sets/clears `packets.shipping_run_id`)
- Delete a shipping run — clears `shipping_run_id` on all linked packets, removes the run record, and removes any linked `tax_invoices` entry
- Business rule: a packet can never appear on more than one run; UI must enforce this when adding to a run

**Tax Invoice Admin:**
- Void a tax invoice (`tax_invoices.status = 'void'`) — does not delete shipping run
- Reissue: create a new `tax_invoices` record with a new INV number linked to the same or corrected shipping run
- Does not duplicate shipping run functionality — shipping run edits done via Shipping Runs Admin
- Future: restrict to admin user only (Gabby) once auth is implemented

## Planned Features
- Proper auth (Supabase email/password)
- CSV matching Solo accounting import
- Records page: shipped/unshipped filter (deferred — spacing constraints)
- Sub-customer address entry UI (currently populated directly in Supabase)
- **Invoice edit / void screen** — View a specific invoice's packets, remove items (sets `packets.shipping_run_id = null`), void (`tax_invoices.status = 'void'`), and reissue with a new INV number. Data model already supports this. Required to enforce the one-invoice-per-packet rule when correcting errors.
- **Invoice search** — Search by INV number, sub-customer, date, amount.
- **NJ billing reconciliation** — View all INV-XXXX numbers in a billing period + totals; print all for sending to Nationwide alongside the accounting system invoice. Defer until Nationwide billing flow confirmed.
- **Alexandra / Queenstown billing review** — Manual test pass: verify Step 2 modal and PDF generation are correct under the unified billing model (no shipping, unaffected by tax_invoices change).

## Future Reports — Split Reconciliation

Since June 2026, Gabby invoices all retailers for the full cost, and Paula invoices Gabby for her split percentage. This means the retailer-facing invoices no longer reflect individual splits. Two reports are needed to support reconciliation:

**1. Paula's Split Report**
For a given billing run or date range, show Paula's share of each packet item — `paula_pct` applied to the discounted cost. This is what Paula invoices Gabby. Should match the amounts on Paula's generated PDFs.

**2. Split Reconciliation Report**
Side-by-side comparison of: (a) what Gabby billed the retailer (full cost after discount), (b) Paula's share (from `paula_pct`), (c) Gabby's effective share (total minus Paula's). Allows both to verify the internal split against the retailer-facing invoice.

These reports should use the same date range / retailer filters as the existing Billing Runs and Customer Report pages.
