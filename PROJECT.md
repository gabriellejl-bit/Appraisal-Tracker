# Billing Tracker - Project Context

## Purpose
Billing tracker for jewellery appraisal work. Paula and Gabby invoice jewellery retailers separately based on their work split percentage per job.

## URLs
- Live: https://gabriellejl-bit.github.io/Appraisal-Tracker/
- Repo: https://github.com/gabriellejl-bit/Appraisal-Tracker

## Stack
- Frontend: Single HTML file (index.html) + external stylesheet (styles.css) - vanilla JS, no framework
- Database: Supabase (PostgreSQL) via REST API - no SDK, raw fetch (all data access, still raw `sbAll`/`sbInsert`/etc.)
- Hosting: GitHub Pages
- Auth: Supabase Auth (email/password) via `supabase-js` (loaded from CDN, used only for `supabaseAuth.auth.*` — not for data access). See "Authentication" section below.
- Backups: GitHub Actions daily cron (`.github/workflows/backup.yml`) — runs `pg_dump` at 2am UTC, commits SQL file to `backups/` on `main`. Requires `SUPABASE_PROD_DB_URL` secret set in GitHub repo settings.

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

## Authentication

Internal staff tool — **no public sign-up**. Staff accounts are created directly in the Supabase dashboard (Authentication > Users), not through the app.

- **Sign in only** — `renderAuthPage()` renders a single login form (email + password) via `supabaseAuth.auth.signInWithPassword()`. No sign-up form exists in the app.
- **Errors are generic** — any sign-in failure (wrong password, unconfirmed email, unknown account) shows only "Invalid email or password". The real Supabase error is never surfaced, so the UI can't be used to enumerate accounts or their state.
- **Route protection** — `render()` gates on `S.session` at the very top: every view falls back to the login page when signed out. The app has no public pages, so this is a single global gate rather than per-route checks.
- **Session persistence** — `supabaseAuth.auth.getSession()` restores an existing session on boot (page refresh); `supabaseAuth.auth.onAuthStateChange()` handles subsequent sign-in/out. `SIGNED_IN` reloads app data and re-renders; `SIGNED_OUT` clears loaded data and re-renders; `TOKEN_REFRESHED`/`USER_UPDATED` update `S.session` silently without calling `render()`, so a background token refresh can't wipe an in-progress Work Packet form draft.
- **Logout** — sidenav "Logout" button calls `supabaseAuth.auth.signOut()`.
- **Authenticated REST calls** — `hdrs()` sends `S.session.access_token` as the bearer token when a session exists, falling back to the anon `SB_KEY` only when signed out (i.e. only for the unauthenticated login page, which makes no data calls).

### Password creation and reset

Staff accounts are still created in the Supabase dashboard (Authentication > Users), but two client-side flows connect to that:

- **Send Invitation (dashboard-triggered)** — inviting a user is an admin-only action done from the dashboard (it needs the service-role key, which the app never has — this is a static site with no backend, so that key can't live in client code). The app only handles the *landing* side: Supabase's invite email links back to the app with the user already signed in; `renderSetPasswordPage()` (reason `'invite'`) shows a "Welcome — set a password to finish creating your account" form, calling `supabaseAuth.auth.updateUser({password})`.
- **Forgot password (self-service, fully client-side)** — a "Forgot password?" link on the login page (`S.authView='forgotPassword'`) calls `supabaseAuth.auth.resetPasswordForEmail(email, {redirectTo: window.location.origin+window.location.pathname})`. Always shows the same generic "If an account exists for that email, a reset link has been sent" message on success, regardless of whether the email is registered — same enumeration-safety principle as the login form. Clicking the emailed link lands back on `renderSetPasswordPage()` (reason `'recovery'`, copy: "Choose a new password").
- **Detecting which link was clicked** — `_authLinkType` is read from the URL (hash or query string, since the format varies) once, synchronously, before Supabase's client strips the tokens. `type=invite`/`type=recovery` sets `S.authMode='setPassword'` at boot, before the first render, so there's no flash of the login page first. The `PASSWORD_RECOVERY` event from `onAuthStateChange` sets the same state as a second, event-driven signal (link formats vary; this is redundant-but-safe insurance, not the primary mechanism).
- **`S.authMode='setPassword'` overrides everything** — checked in `render()` ahead of the `S.session` gate, so it takes priority over both the login page and the app shell. If no session exists when this screen renders (expired/already-used link), it shows a "Link expired" dead-end with a button back to login instead of a form that would just fail on submit.
- **Prerequisite — Supabase dashboard config (per project, dev and prod separately):** the `redirectTo` URL used above must be added to that project's Auth → URL Configuration → Redirect URLs allowlist, or Supabase silently falls back to the default Site URL instead. Not yet confirmed configured — check both Supabase projects before relying on this in production.

### profiles table (real display name + appraiser mapping)
`id UUID PK (references auth.users.id), full_name TEXT, appraiser_id INTEGER (references users.id, nullable)`

Not self-service — rows are inserted manually via SQL/dashboard alongside creating the Auth user. RLS: enabled, with a single policy `auth.uid() = id` (a user can only read their own row).

- `loadAll()` fetches the caller's own row (`&id=eq.<session.user.id>`) into `S.profile`, wrapped in its own try/catch — a missing table or row never blocks login, the header just falls back to showing the raw email.
- Topbar header shows `S.profile.full_name` (falls back to `session.user.email` if no profile row exists).
- `applyAppraiserDefault()` runs once per login/session-restore, right after `loadAll()`: looks up `S.profile.appraiser_id` in `S.users`, and sets `S.user` (the G/P work-attribution toggle) to that appraiser's `slug` as the *default*. The toggle buttons still work normally afterward — this only sets where you land, it doesn't lock the toggle.
- Unmapped accounts (no profile row, or `appraiser_id` is null/unrecognised) default to `'gabby'`. This is a placeholder — a proper Admin view for non-appraiser logins (e.g. office/admin accounts) is planned; the avatar toggle may be replaced by something else once that exists.
- **Known gap found during release testing:** an anon-key request against the dev project currently gets `permission denied` (`42501`) on both `profiles` and `users` — worth checking `GRANT SELECT ... TO authenticated` (and RLS policies generally) in the Supabase dashboard before relying on `profiles` in production. This shouldn't affect the app itself (which only ever queries with a session, i.e. as `authenticated`, never as `anon`), but hasn't been verified end-to-end with a real confirmed login.

  **RESOLVED — expected, not a bug.** Anon access to `profiles` and `users` was deliberately revoked as part of a security lockdown: RLS policies were replaced with authenticated-only access, then `revoke ... from anon` was run on each table. The app never relies on anon access to these tables — it only ever queries them post-login as the `authenticated` role, so the 401/42501 an anon-key request gets is the intended behaviour, not a misconfiguration. Confirmed working via manual login test as both real users (Gabby and Paula) after this change. Do not re-flag this as a bug in a future release.

**Security note:** login adds real *authentication*, and RLS is now enabled on `profiles` and `users` (anon access revoked, authenticated-only policies — see "RESOLVED" note above). Most other tables (`packets`, `items`, `job_types`, etc.) still have RLS disabled — the anon publishable key can read/write them regardless of login state. Locking down the rest is a separate, not-yet-done piece of work.

---

## Infrastructure

### Daily Database Backup
`.github/workflows/backup.yml` — runs on a cron schedule (2am UTC daily) and can be triggered manually via `workflow_dispatch`.

- Installs **PostgreSQL 17 client** explicitly (`/usr/lib/postgresql/17/bin/pg_dump`) — must match Supabase's server version (17). The default Ubuntu `postgresql-client` package is older and will refuse to dump a newer server.
- GitHub Actions runners are **IPv4-only**. Supabase direct connections default to IPv6. Use the **Session pooler** connection string (not Direct connection) to avoid "Network is unreachable" errors. The session pooler URI looks different from the direct URI — get it from the Supabase Connect modal with "Session pooler" selected.
- Requires `SUPABASE_PROD_DB_URL` secret in GitHub → Settings → Secrets and variables → Actions. Value is the PostgreSQL URI from Supabase Connect modal (session pooler, URI type): `postgresql://postgres.[project-ref]:[PASSWORD]@aws-0-ap-southeast-2.pooler.supabase.com:5432/postgres`
- Backup files are committed to `backups/` on `main` as `backup_YYYY-MM-DD_HH-MM-SS.sql`.

### Tax Invoice PDF (`printInvoice`)
Generated via `window.open()` + `document.write()` — a new browser window, not an iframe or download.

- **Images must be base64 data URIs** — the popup window has no base URL, so relative paths like `/assets/images/logo.png` resolve to nothing. Convert with `base64 -i file.png | tr -d '\n'` and embed as `data:image/png;base64,...`.
- **Suppress browser print headers/footers** with `@page { margin: 0; }` in the popup's `<style>`. Compensate with `body { padding: 20mm; }` in `@media print`.
- **Logo asset:** `assets/images/PGL-FULL-LOGO.png` (circular gold logo, 100×100 in invoice). Embedded as base64 in the `printInvoice` function.

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

**CRITICAL — never use text as a primary key or foreign key.** All IDs must be integers (auto-increment) or UUIDs. Text slugs (e.g. `sc_jewelcraft`) are display names only — never use them as PK/FK values. Text-based linking is fragile: a rename breaks every reference silently with no constraint error. Learned the hard way when `sub_customers` used text slugs as PKs and had to be migrated to integer FKs.

### items (lookup)
`name TEXT PK, display_order INTEGER`
WARNING: no id column. Sort: `&order=display_order.asc`

### job_types (lookup)
`id, name, cost DECIMAL, display_order INTEGER`. Sort: `&order=display_order.asc`

### sub_customers
`id, retailer_id FK, name TEXT, display_order INTEGER, address_line1 TEXT, suburb TEXT, city TEXT, postcode TEXT`
NJ sub-customers. Loaded into `S.subCustomers`. Address fields used in tax invoices.

### profiles
`id UUID PK (= auth.users.id), full_name TEXT, appraiser_id FK→users.id (nullable)`
Not app-writable — rows created manually alongside each Supabase Auth staff account. RLS enabled (self-read-only). Loaded into `S.profile` (single row for the logged-in account). See "Authentication" section above for how it's used.

### packets
`id TEXT PK, date TEXT (DD MMM YYYY), retailer_id FK, customer_ref TEXT, sub_customer_id FK→sub_customers.id (nullable, NJ only), surname TEXT, status_id FK, paula_billed BOOLEAN, gabby_billed BOOLEAN, shipping_run_id FK (nullable), created/modified TEXT`
Legacy column `sub_customer TEXT` still exists but is not read by app code — use `sub_customer_id`.

### packet_items
`id TEXT PK, packet_id FK, item TEXT, job_type_id FK, cost DECIMAL, paula_pct INTEGER, gabrielle_pct INTEGER (sum to 100)`
`cost` is stored **ex-GST**. Never divide by 1.15. Use raw cost on customer invoices — do NOT apply `discount_pct`.

### shipping_runs
`id TEXT PK, ship_date TEXT, shipping_cost DECIMAL (GST-INCLUSIVE), tracking_last4 TEXT, retailer_id FK, sub_customer_id FK→sub_customers.id (nullable), sub_customer_name TEXT (nullable, legacy), invoice_number TEXT (nullable, INV-XXXX, NJ only), packing_slip_number TEXT (nullable, PS-XXXX, Direct only), created TEXT`

**CRITICAL — shipping_cost is stored GST-inclusive.** Divide by 1.15 for ex-GST display. Default input value is $6. `getShippingForBilling()` pre-computes `totalExGST` and `bySubCustomerExGST`.

### tax_invoices
`id TEXT PK, invoice_number TEXT UNIQUE (INV-XXXX format), shipping_run_id FK, issue_date TEXT, retailer_id FK, sub_customer_id FK→sub_customers.id (nullable), sub_customer_name TEXT (nullable, legacy), status TEXT ('active'|'void'), created TEXT`
One record per NJ shipping run. `invoice_number` also denormalized onto `shipping_runs` for fast display. Packets inferred via `packets.shipping_run_id`. Loaded into `S.taxInvoices`.

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
Right: [+ New Packet] [G/P work-attribution toggle] [logged-in identity: name/email from `profiles`/session]
Sidenav General section: Admin · Logout (signs out via `supabaseAuth.auth.signOut()`)
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
- `getCurrentUser()` — full user row for the **work-attribution toggle** (`S.user`, G/P), call once per function. Not the logged-in identity — use `S.session.user` / `S.profile` for that (see "Authentication"). These two were previously conflated (the header briefly showed the toggle's name instead of the real login), so keep them separate: `S.user` drives business logic and can be switched anytime via the avatars; `S.session`/`S.profile` reflect who's actually authenticated and should never change when the avatars are clicked.
- `scName(id)` — resolves `sub_customers.id` → display name; use everywhere instead of raw `sub_customer_name`
- `getDollarStats()` — `{unbilled, earnedWeek, earnedMonth}` POST-TAX, POST-DISCOUNT
- `packetCosts(id)` — applies retailer `discount_pct`, returns `{total, paula, gabby}` (billing use only — NOT for invoices)
- `packetBillingLabel(pkt)`, `userHasBilled(pkt)`, `userHasNoWork(pktId)`
- `getBillingItems()`, `isRetailerCombined(retailerId)`, `invoiceGroup(jtName)`
- `buildInvoiceSummary(items, retailerId)` — returns `{byJobType, bySubCustomer, subtotal, gst, total, discountPct, isNJRetailer, isCombined, isCombinedGabby, isCombinedPaula}`
- `getShippingForBilling(retailerId)` — returns `{total, totalExGST, bySubCustomer, bySubCustomerExGST, bySubCustomerRunCount, runs, runCount, dateLabel}`
- `nextInvoiceNumber()` — returns next `INV-XXXX` string
- `generatePDFContent(retailerId)` — text lines for detailed billing PDF
- `retailerName(id)`, `statusName(id)`, `fmtMoney(n)`, `fmtD(d)`, `getDateRange(key)`

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
- Future: restrict to admin user only (Gabby) — auth now exists, but the Admin view itself is not yet gated by it

## Planned Features
- Admin dashboard for non-appraiser logins — accounts with no `appraiser_id` mapping currently default to Gabby's view; the G/P avatar toggle may be replaced by something else once this exists
- RLS policies on the remaining tables (`packets`, `items`, `job_types`, etc.) — `profiles` and `users` have RLS enabled (authenticated-only, anon revoked); the rest are still open to the anon key
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
