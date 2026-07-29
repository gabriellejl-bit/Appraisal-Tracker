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
- **Anon access to `profiles`/`users` is deliberately revoked, not a bug.** An anon-key request against either table gets `permission denied` (`42501`) by design — RLS policies were replaced with authenticated-only access and `revoke ... from anon` was run on each. The app never relies on anon access to these tables; it only ever queries them post-login as the `authenticated` role. Confirmed working via manual login test as both real users (Gabby and Paula). Do not re-flag this as a bug in a future release.

**Security note:** login adds real *authentication*. RLS state varies per table — **do not assume any table's RLS/policy state from this doc; verify directly** before relying on it:
```sql
SELECT relname, relrowsecurity FROM pg_class WHERE relname = '<table>';
SELECT tablename, policyname, roles, cmd, qual, with_check FROM pg_policies WHERE tablename = '<table>';
```
This doc previously claimed "most tables besides `profiles`/`users` have RLS disabled" — that was wrong and cost real debugging time (a 403 on a new table was mistaken for a config mistake rather than checked directly). Verified as of 2026-07-15:
- `profiles`, `users`: RLS enabled, per-row policy (`auth.uid() = id`) — self-read-only, anon revoked.
- `packets`, `tax_invoices`: RLS enabled, blanket policy named `"Authenticated staff access"` — `FOR ALL TO authenticated USING (true) WITH CHECK (true)`. Any authenticated session can do anything to these rows; there's no per-user restriction, matching this app's internal-staff-tool model (all logged-in accounts are trusted staff).
- `nj_statements`, `nj_statement_lines`, `nj_credit_notes`: RLS **disabled** — anon key can read/write freely.
- Other tables (`items`, `job_types`, `sub_customers`, `shipping_runs`, `billing_runs`, `retailers`, `billing_statuses`) — **not verified**, don't assume either way.

When adding a new table: Supabase's SQL editor can silently enable RLS with zero policies, which 403s every request (this bit `nj_payments` during the NJ Statement redesign — `CREATE TABLE` left RLS on with no policy, and a same-script `DISABLE ROW LEVEL SECURITY` line was never actually run because testing paused before it executed). After creating a table, immediately check its actual state with the queries above — don't trust the migration script's intent, confirm the result.

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
`id TEXT PK, ship_date TEXT, shipping_cost DECIMAL (GST-INCLUSIVE), shipping_cost_billed DECIMAL (GST-INCLUSIVE, nullable), tracking_last4 TEXT, retailer_id FK, sub_customer_id FK→sub_customers.id (nullable), sub_customer_name TEXT (nullable, legacy), invoice_number TEXT (nullable, INV-XXXX, NJ only), packing_slip_number TEXT (nullable, PS-XXXX, Direct only), created TEXT`

**CRITICAL — shipping_cost is stored GST-inclusive.** Divide by 1.15 for ex-GST display. Default input value is $6. `getShippingForBilling()` pre-computes `totalExGST` and `bySubCustomerExGST`.

**`shipping_cost` vs `shipping_cost_billed`:** Nationwide's 8.5% commission is taken off everything on the statement, including shipping, so invoicing them the same amount PGL pays the fulfilment partner loses money on every shipment. `shipping_cost` stays the raw, untouched fulfilment-partner charge — what PGL actually owes them, used for the Fulfilment Summary report. `shipping_cost_billed` is a separate, frozen, GST-inclusive figure computed once at shipment-creation time via `njBilledShippingCost()` (`shipping_cost × 1.10` for NJ runs only, rounded to cents; equals `shipping_cost` for non-NJ runs) — this is what actually goes on the tax invoice/statement. Every invoicing/statement code path reads `run.shipping_cost_billed??run.shipping_cost` (the `??` fallback covers runs shipped before this column existed) — never recompute the markup downstream. 10% was chosen deliberately over the exact breakeven rate (8.5%/(1-8.5%)≈9.29%) as a rounder, less obvious number.

### tax_invoices
`id TEXT PK, invoice_number TEXT UNIQUE (INV-XXXX format), shipping_run_id FK, issue_date TEXT, retailer_id FK, sub_customer_id FK→sub_customers.id (nullable), sub_customer_name TEXT (nullable, legacy), status TEXT ('active'|'void'), nj_statement_id FK→nj_statements.id (nullable), paid_date TEXT (nullable), paid_via_payment_id FK→nj_payments.id (nullable), created TEXT`
One record per NJ shipping run. `invoice_number` also denormalized onto `shipping_runs` for fast display. Packets inferred via `packets.shipping_run_id`. Loaded into `S.taxInvoices`. `nj_statement_id` is null when the invoice hasn't been put on a statement yet (i.e. it's eligible for the next one's "new lines") — permanent once set, never moved back to null except by voiding that statement. `paid_date`/`paid_via_payment_id` are set together by `recordNJPayment()` — this is the entity actually tracked for payment (per Gabby: "the tax invoice is the entity we track payment against"), not the statement. See "Nationwide Jewellers — Statement" below.

### nj_statements
`id TEXT PK, period_start TEXT, period_end TEXT, generated_date TEXT, statement_date TEXT (nullable), subtotal DECIMAL, gst DECIMAL, total DECIMAL, opening_balance DECIMAL, aging_current DECIMAL, aging_30 DECIMAL, aging_60 DECIMAL, aging_90 DECIMAL, accounting_ref TEXT (nullable), status TEXT ('draft'|'final'|'void'), paid_date TEXT (nullable, legacy/unused), created TEXT`
One row per monthly consolidated statement sent to Nationwide. `period_start`/`period_end` are descriptive labels only (auto-derived from included lines) — legacy, predates `statement_date`. `statement_date` (`YYYY-MM-DD`, always a month-end) is the real eligibility cutoff: the builder's Month selector sets it, and `njLinePool()` excludes any tax invoice/credit note/payment dated after it. `subtotal`/`gst`/`total` are this statement's own **new lines this period only** (invoices/credits/payments first shown here) — NOT the amount owed. `opening_balance` and the four `aging_*` columns are a **frozen snapshot**, computed fresh from live `tax_invoices` via `njCurrentBalance()` and written once at Save Draft/Finalize time (see `saveNJDraft()`) — closing balance is always `opening_balance + total`, never a separately stored field. Critically: these frozen fields are for THIS statement's own reprint fidelity only — nothing downstream ever reads them back in as an input to a later statement's calculation (that chain-of-trust was the old design's bug — see below). `paid_date` predates the payment-entity redesign and is no longer read by any code path; kept only so old rows don't error on load.

### nj_payments
`id TEXT PK, amount DECIMAL, received_date TEXT, reference TEXT (nullable), nj_statement_id FK→nj_statements.id (nullable), status TEXT ('active'|'void'), created TEXT`
A real, reconciled payment from Nationwide — recorded once via Admin's "Record Payment" (`recordNJPayment()`), reconciled against any currently-unpaid tax invoice regardless of which period it's from (bank-reconciliation style, all-or-nothing per invoice — no partial-invoice payment). `nj_statement_id` follows the same "first presented" pattern as `tax_invoices`/`nj_credit_notes`: null until shown as a new line on the next statement built, then permanent. RLS is enabled on this table (unlike its `nj_statements`/`nj_statement_lines`/`nj_credit_notes` siblings, which have RLS disabled) — needs the same `"Authenticated staff access"` policy `packets`/`tax_invoices` use, see the Authentication section's Security note.

### nj_statement_lines
`id TEXT PK, statement_id FK→nj_statements.id, line_type TEXT ('invoice'|'credit'|'payment'), tax_invoice_id FK (nullable), credit_note_id FK→nj_credit_notes.id (nullable), payment_id FK→nj_payments.id (nullable), sub_customer_name TEXT, amount DECIMAL (signed — negative for credit/payment lines)`
Frozen snapshot of a statement's own **new lines** (never its opening balance — that's computed live, see `nj_statements` above), written at Save Draft/Finalize time — never recomputed, so reprinting an old statement can't silently change its historical line items. Loaded into `S.njStatementLines`. The old `brought_forward`/`payment`-as-statement-total line types and `carried_statement_id` column are gone — that carry-forward mechanism was the source of the original double-counting bug (see below); `'payment'` here means an actual `nj_payments` row, not a lump statement total.

### nj_credit_notes
`id TEXT PK, source_payment_id FK→nj_payments.id, nj_statement_id FK→nj_statements.id (nullable), accounting_ref TEXT (nullable), subtotal DECIMAL, gst DECIMAL, total DECIMAL, issue_date TEXT, status TEXT ('draft'|'void'), created TEXT`
Nationwide's commission on a specific payment — auto-generated the moment `recordNJPayment()` runs, as `ticked-invoice total minus actual payment amount` (not a fixed 8.5% calculation), dated the **same day** as the payment. No separate paid/reconciliation tracking (a credit note is a deduction Nationwide already took, not something owed back — it's fully resolved the instant it's created; only `status='void'` is meaningful, set when its payment is voided). `nj_statement_id` is null until shown as a new line on a later statement (mirrors `tax_invoices`). Loaded into `S.njCreditNotes`.

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
- `isRetailerCombined(retailerId)` checks `combined_billing` flag — currently dead code, every actual check in the codebase uses a hardcoded `retailer.name==='Nationwide Jewellers'` comparison instead. Noted, not cleaned up.
- The above (`getBillingItems()`, Step 1–4) is still Paula's path for invoicing Gabby her share, and is available to Gabby as a manual fallback. It is **not** how Gabby actually bills Nationwide any more — see below.

**Nationwide Jewellers — Statement, Credit Notes & Reconciliation (Gabby's actual NJ billing path):**

Gabby doesn't bill Nationwide per-retailer through the Run Billing wizard. Selecting Nationwide Jewellers in Step 1 and clicking Start goes to a **chooser screen** (`renderNJChooser()`, `S.billing.step==='nj'`) instead of Step 2: "Generate NJ Statement" (below) or "Continue to invoice wizard" (the unchanged Step 2–4 wizard above, what Paula uses).

Three real-world documents, only the second is built in this app:
1. **Tax Invoice** — existing, unchanged. Per shipping run, per sub-customer, full undiscounted cost. Nationwide requires a copy of every tax invoice forwarded to their office at least weekly (manual step, not automated). This is the entity payment is actually tracked against — see below.
2. **Statement** — one consolidated statement per month, rolling up that period's new tax invoices/credit notes/payments plus a live-computed opening balance into an accounting-style document sent to Nationwide and separately hand-entered into the real accounting system. Built via `renderNJStatementBuilder()` / `S.view==='njStatement'`.
3. **Credit Note** — Nationwide's ~8.5% commission isn't a discount applied at invoicing or statement time — Gabby bills the full amount, Nationwide pays less, and a credit note documents that shortfall.

**Redesigned 2026-07: payment tracked on invoices, not carried forward statement-to-statement.** The original design modelled each statement as carrying forward the previous statement's *stored total* (`brought_forward`/`payment` line types referencing another statement's `subtotal`/`gst`/`total`). This was the actual bug: a wrong stored total on one statement silently poisoned every later statement that trusted it, with no way to trace which invoice was the problem. The fix — confirmed with Gabby, who put it simply: *"the balance should be a total of all non-paid tax invoices, not something carried forward statement-to-statement"*:
- **`paid_date`/`paid_via_payment_id` live on `tax_invoices` itself** — payment is tracked per-invoice, not per-statement.
- **A real `nj_payments` entity** records what actually came in: amount, date, reference, and which invoices it settles (any period, ticked like a bank reconciliation — see `recordNJPayment()`).
- **The credit note is the arithmetic difference** — `(ticked invoice total) − (payment amount)` — not a fixed 8.5% calculation, auto-generated the same day as the payment.
- **Balance is always `njCurrentBalance(asOfDate)`** — a live sum over `tax_invoices where status='active' and nj_statement_id IS NOT NULL and (paid_date IS NULL OR paid_date > asOfDate)`, bucketed by age. The `asOfDate` awareness (not just `paid_date IS NULL`) is what prevents a payment recorded *during* a period from silently double-subtracting itself — once via disappearing from the live "unpaid" pool, once via its own explicit new-line entry. Never a stored total read back in as another calculation's input.
- **A statement's own `opening_balance`/`aging_*` are a one-time frozen snapshot** of that same live computation, taken at Save Draft/Finalize time, purely for that statement's own reprint fidelity — the next statement always recomputes its own opening balance fresh (which mathematically equals the prior statement's closing balance, but arrives there independently, not by reading the prior row).

**Statement lifecycle:** `draft` (add/remove eligible new-lines, live opening balance + totals, preview freely, nothing persisted until Save Draft) → `final` (Finalize: bills the underlying packets — `gabby_billed=true` unconditionally, `status_id` only flips to Billed if `paula_billed` is already genuinely true, no shortcut — see bug note below) → `void` (Admin only, releases invoice/credit/payment lines back to the eligible pool and reverts packet billing; refuses if the statement's own credit note has already been used on a later statement rather than guessing at an unwind). There is no more statement-level "Paid" state — see "Recording a payment" below, which is independent of any specific statement.

**Selection logic for a statement's "new lines" — deliberately not based on `packets.gabby_billed`, `status_id`, or split %:**
- Invoice lines: `tax_invoices` where `retailer_id=NJ`, `status='active'`, `nj_statement_id IS NULL`, `issue_date` on/before the builder's selected month-end cutoff (see Month selector below)
- Credit lines: `nj_credit_notes` where `status='draft'`, `nj_statement_id IS NULL`, same month-end cutoff
- Payment lines: `nj_payments` where `status='active'`, `nj_statement_id IS NULL`, `received_date` on/before the same cutoff — same "first presented, then permanent" pattern as invoices/credit notes.
- The statement's **opening balance** is not a "line" at all — it's `njCurrentBalance()` computed as of the *start* of the selected month (`njMonthEndDate(njPrevMonthKeyOf(b.month))`), shown separately above the new-lines table and frozen onto the statement row at save time.

**Recording a payment** (`recordNJPayment(amount, receivedDate, reference, invoiceIds)`, Admin → NJ Payments → "Record Payment"): independent of any particular statement. Tick any currently-unpaid, already-presented invoice (any period — a payment can catch up a multi-month backlog in one go), enter the amount actually received; sets `paid_date`/`paid_via_payment_id` on every ticked invoice and auto-generates one credit note for the shortfall. **No cascade/recursion needed** — because an older unpaid invoice is already part of the live balance regardless of which statement first showed it, there's nothing to chase up a chain. `voidNJPayment(id)` reverses exactly this: un-pays the invoices it settled, voids its credit note. No "used elsewhere" refusal needed (unlike statement void) since a payment never cascades into packet billing.

**Month selector (builder screen):** `S.njStatement.month` (`'YYYY-MM'`) is set on a fresh draft to `njNextOpenMonth()` — the month right after the most recently finalized statement — or inferred from the resumed draft's `statement_date`/`period_end` so already-attached lines don't drop out. `njMonthOptions()` deliberately returns **only that single month**, not a historical dropdown: a period can only ever be finalized once, and re-selecting an already-finalized month would recompute Opening Balance against a cutoff that's no longer the right question to ask (real bug found in testing — looked like a stale balance, was actually a UI gap letting a done period be reopened). Sets `nj_statements.statement_date` (month-end, `'YYYY-MM-DD'`) via `saveNJDraft()`. `njMonthEndDate()`/`njPrevMonthKey()`/`njPrevMonthKeyOf(monthKey)`/`njNextOpenMonth()`/`njMonthKeyFromDate()`/`njMonthOptions()` are the supporting helpers — all use explicit `new Date(y,m-1,d)` local construction, never `new Date(isoString)` or a `toISOString()` round-trip, to avoid the UTC day-shift bug noted elsewhere in this file.

**Known pre-existing bug this sidesteps, not fixed:** `renderBillingStep4()` and the manual per-packet billing toggle both auto-flip `status_id` to Billed when the *other* user has 0% on every item in a packet — correct for standard retailers, wrong for NJ (Gabby always owes Nationwide the full invoice regardless of her %). If Paula bills a 100%-Paula NJ packet first via the old wizard, `status_id` can show "Billed" in Records/Dashboard before Gabby has actually put it on a statement. The Statement flow's selection logic above is immune to this, but the on-screen label can still mislead. Interim workaround: bill Gabby first where practical.

**Admin** (`renderAdmin()`, alongside the still-stubbed Shipping Runs Admin / Tax Invoice Admin): two separate cards.
- **NJ Statements** (`njReconciliationCard()`) — lists finalized statements with their frozen opening balance/total. Void only; Mark as Paid no longer lives here (or anywhere on a per-statement basis).
- **NJ Payments** (`njPaymentsCard()`) — lists recorded payments (date, reference, amount, linked credit note, status), "Record Payment" button opens `showRecordNJPaymentModal()` (amount/date/reference + a checklist of every currently-unpaid invoice, live credit-note preview), per-row Void via `showVoidNJPaymentConfirm()`.

**Key helpers:** `njRetailer()`, `njTaxInvoiceAmount(ti)` (recomputes a tax invoice's GST-inclusive total from its packets, same math as `printInvoice()`), `njCurrentBalance(asOfDateISO)` (the live balance/aging computation — the core fix; used by the builder's opening-balance display, `saveNJDraft()`'s frozen snapshot, and `printStatement()`'s reprint), `njLinePool()` (eligible new-lines pool described above), `njStatementPeriodLabel(st)`, `saveNJDraft()`, `finalizeNJStatement()`, `recordNJPayment(amount,receivedDate,reference,invoiceIds)`, `voidNJPayment(id)`, `voidNJStatement(id)`, `printStatement(id)` (reuses `printInvoice()`'s popup/base64-logo pattern via the shared `PGL_LOGO_B64` constant — extracted from `printInvoice()` so both share one copy instead of duplicating the ~32KB logo).

**Still open:** Nationwide's Bill-To address on the printed Statement is the AU head-office address from their supplier procedure doc (flagged inline with a code comment) — not yet confirmed correct for NZ-issued statements. The discount-leak in `buildInvoiceSummary()` (discount applied before splitting by `paula_pct`/`gabrielle_pct`, so Paula's NJ share is under-calculated by 8.5%) is also still unfixed — see rule 21 in `CLAUDE.md`. Credit note lines print their date range as the reference (`'Credit note — Payment '+date`) instead of a real credit note number — standard invoicing practice expects a proper number the same way tax invoices get `INV-XXXX`; `nj_credit_notes` has no numbering scheme yet. **Prod status:** shipped 2026-07-15 (commit `a0bc296`) — prod has all 4 NJ tables and the associated `tax_invoices`/`shipping_runs` columns, currently empty (no real statements run through prod yet). Known gap: prod is missing 6 FKs that dev has (`nj_credit_notes_nj_statement_id_fkey`, `nj_statement_lines_credit_note_id_fkey`, `nj_statement_lines_statement_id_fkey`, `nj_statement_lines_tax_invoice_id_fkey`, `tax_invoices_nj_statement_id_fkey`, `packets_shipping_run_id_fkey`) — dev's schema is correct here, prod's migration script just omitted them; fix is additive FKs on prod, not removing them from dev.

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
Reports nav active for: reports, billingRunsReport, customerReport, taxInvoices, shippingReport, fulfilmentReport, njStatementsReport, njMonthlySplitCsv, jamiesShippingReport.
Shipping nav active for: shipping, shippingReport, fulfilmentReport.
NJ Statement flow lives under `S.view==='njStatement'` (`renderNJStatement()`, dispatches on `S.njStatement.step`: `'builder'`/`'history'`) — reached only via the Run Billing chooser, not its own nav item.

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
1. Selection: date filter (default last month), status filter. Auto-selects eligible items via `b.initialised` flag. **NJ retailer:** Start is enabled once the retailer is picked, regardless of item selection — the Statement path below doesn't depend on `selectedItemIds` at all, so gating it the same as every other retailer made the chooser unreachable whenever nothing was left to bill via the old per-item flow.
2. Retailer modal loop: invoice summary (copy/paste) + items table. GST conditional. NJ groups by sub-customer.
3. PDFs: jsPDF A4, Courier monospace. NJ groups by shipping run/invoice.
4. Confirm: sets per-user billed flags, saves billing run.

**NJ chooser** (between Step 1 and 2, NJ retailer only): "Generate NJ Statement" → below, or "Continue to invoice wizard" → unchanged Step 2–4 (Paula's path).

### NJ Statement Builder
Draft-building view (`renderNJStatementBuilder()`). Live Opening Balance summary (via `njCurrentBalance()`) above a table of eligible new lines — tax invoices/credit notes/payments, sorted oldest to newest (matching print order), all pre-checked (same auto-select-then-deselect pattern as Shipping/Step 1). Below: Subtotal (new invoices) / GST / Total (new invoices) — invoice-only figures, deliberately not netted against credit/payment amounts — then a single "Payments / Credits" gross line, then Closing Balance (opening + invoice total + payments/credits). Nothing persists until Save Draft or Finalize (matches the Run Billing wizard's own in-memory-until-confirm pattern). Save Draft / Generate Statement / Review & Finalize / Cancel.

### NJ Statement History
Read-only-ish list (`renderNJStatementHistory()`, `S.njStatement.step==='history'`, reached via a link on the chooser screen): Period, Generated date, Status, Total, inline-editable Accounting Ref. Draft → Edit/Preview. Final → Reprint only — Void lives in Admin instead, not here (and there's no more Mark as Paid anywhere per-statement — see "Recording a payment" above).

### Reports
Landing page → Billing Runs, Customer Report, Tax Invoices, Shipping Audit, Fulfilment Summary, Nationwide Statements, Nationwide Monthly Split (CSV), Jamies Monthly Shipping.

### Billing Runs
Billing run history. Regenerate PDFs. Delete run.

### Customer Report
Filter: date range + retailer. Groups by retailer, lists items per customer. Download PDF.

### Tax Invoices
Filter: sub-customer + date range. Flat list of NJ tax invoices (invoice #, date, sub-customer, packet count, GST-inclusive amount via `njTaxInvoiceAmount()`) with a Reprint action per row.

### Shipping
- Filter: retailer/sub-customer. Lists unshipped packets with checkboxes.
- "Create Shipment" CTA → two-step modal: (1) packet table + shipping cost → Print Invoice (NJ) or Print Packing Slip, (2) ship date + tracking → Mark as Shipped.

### Shipping Audit
Expandable per-run rows. Columns: Date, Retailer/Sub-customer, Invoice, Tracking, Packets, Cost. Shows `INV-XXXX` for NJ runs.

### Fulfilment Summary
Flat list of all shipping runs with packet counts and costs.

### Nationwide Statements
Historical drill-down report (`renderNJStatementsReport()`), separate from the Statement Builder/History above — built so a specific tax invoice or packet number can be found without regenerating and reading back through PDFs. Filters: Date Range (statement date, default This FY), Sub-customer, and a Search box matching invoice number or packet ref (`customer_ref`) — Search deliberately ignores the Date Range filter (you're hunting for a specific thing, not browsing a period) and narrows/hides non-matching invoice lines within each statement rather than hiding the whole statement. Only `status==='final'` statements are shown (void ones are hidden entirely, not greyed out). Each matching statement renders as its own section: header (Statement Date, Status, Opening/This Statement/Closing balance) above a table of that statement's frozen `nj_statement_lines`, with invoice rows expandable (same chevron interaction as the Statement Builder) to show that invoice's packets via the existing `packetsForTaxInvoice()` helper.

### Nationwide Monthly Split (CSV)
Reconciliation data dump (`renderNJMonthlySplitCsv()`/`njMonthlySplitCsvData()`), built to check Paula isn't under/over-billing Gabby given the 8.5% NJ discount interaction, and to reconcile shipping against the fulfilment partner and Nationwide's own statement. Filter: standard Date Range dropdown (default Last Month) — filters valuation rows by **packet date** (deliberately, so the CSV shows the gap between a packet being entered and it actually being shipped/invoiced) and shipping rows by **ship date** independently. On-screen: packet/item/shipment counts, a Valuations split totals table (Nationwide/Paula/Gabby × without/with the 8.5% discount), a Shipping totals table (Owed to Fulfilment Partner / Charged to Nationwide / Margin), and a Download CSV button.

CSV column order: Type, Tax Invoice Date, Tax Invoice #, Packet Date, Ref, Surname, Sub-customer, Description, Item Cost (Raw), Item Cost +GST, Paula %, Gabby %, Paula (No Discount), Gabby (No Discount), Paula (8.5% Discount), Gabby (8.5% Discount), Owed to Fulfilment Partner, Charged to Nationwide, Shipping Less GST, Paula Billed, Gabby Billed — driven by a single `NJ_SPLIT_CSV_COLS` ordered list (`njSplitCsvRowValues()`) rather than hand-aligned arrays, so reordering columns is a one-line change. Valuation rows: tax invoice # / date come from the packet's shipping run's `tax_invoices` row, blank if not yet shipped/invoiced (the point — shows what's billing-complete but not yet invoiced). Shipping rows skip every Paula/Gabby split column (Paula never bills shipping) but repeat "Charged to Nationwide" into "Item Cost +GST" too, so that one column summed top-to-bottom (valuations + shipping) gives the whole GST-inclusive invoice total to check against the statement; "Shipping Less GST" is that same charged figure ÷ 1.15. Row order: grouped by invoice (via a sort key of invoiceDateISO → invoiceNumber → packetDateMs so same-invoice rows stay contiguous even when two invoices share a date), each invoice's packets followed immediately by its shipping row; un-invoiced packets sort last (no shipping row to pair with); any shipment whose packets fell outside the selected range still gets listed, appended at the very end. Totals row at the bottom sums every money column.

### Jamies Monthly Shipping
For the fulfilment partner to invoice against (`renderJamiesShippingReport()`). Month dropdown via `jamiesMonthOptions()` — current month plus the last 6 completed ones, defaulting to last month (index 1; current month is included so the running total can be checked before the month closes, but isn't the default since the partner only invoices for a complete month). Table: Date, Shipping Number (`invoice_number` for NJ / `packing_slip_number` for Direct), Sub-customer, Amount — the raw `shipping_cost` as entered, never `shipping_cost_billed` (NJ's 10% markup is an internal Nationwide-billing figure, not what the fulfilment partner actually charged) and never GST-adjusted. Totals row: "Total (incl GST)".

---

## Code Conventions

**State (S):** See CLAUDE.md for full field list.

**Render:** `render()` = full DOM rebuild. `renderAsync()` = pre-fetches edit data first. Never call from inside a form.

**Toast:** `toast()` calls `render()` — never inside forms. Use `showToast()` (direct DOM inject, safe anywhere).

**Key helpers:**
- `getCurrentUser()` — full user row for the **work-attribution toggle** (`S.user`, G/P), call once per function. Not the logged-in identity — use `S.session.user` / `S.profile` for that (see "Authentication"). These two were previously conflated (the header briefly showed the toggle's name instead of the real login), so keep them separate: `S.user` drives business logic and can be switched anytime via the avatars; `S.session`/`S.profile` reflect who's actually authenticated and should never change when the avatars are clicked.
- `scName(id)` — resolves `sub_customers.id` → display name; use everywhere instead of raw `sub_customer_name`
- `packetRetailerLabel(p)` — resolves a packet's display retailer name (sub-customer name if genuinely theirs, else the retailer's own name); use instead of a bare `scName(p.sub_customer_id)||retailerName(p.retailer_id)`, which trusts a possibly-stale `sub_customer_id` — see CLAUDE.md rule 24
- `getDollarStats()` — `{unbilled, earnedWeek, earnedMonth}` POST-TAX, POST-DISCOUNT
- `packetCosts(id)` — applies retailer `discount_pct`, returns `{total, paula, gabby}` (billing use only — NOT for invoices)
- `packetBillingLabel(pkt)`, `userHasBilled(pkt)`, `userHasNoWork(pktId)`
- `getBillingItems()`, `isRetailerCombined(retailerId)`, `invoiceGroup(jtName)`
- `buildInvoiceSummary(items, retailerId)` — returns `{byJobType, bySubCustomer, subtotal, gst, total, discountPct, isNJRetailer, isCombined, isCombinedGabby, isCombinedPaula}`
- `getShippingForBilling(retailerId)` — returns `{total, totalExGST, bySubCustomer, bySubCustomerExGST, bySubCustomerRunCount, runs, runCount, dateLabel}`
- `nextInvoiceNumber()` — returns next `INV-XXXX` string
- `generatePDFContent(retailerId)` — text lines for detailed billing PDF
- `retailerName(id)`, `statusName(id)`, `fmtMoney(n)`, `fmtD(d)`, `getDateRange(key)`
- `njRetailer()`, `njTaxInvoiceAmount(ti)`, `njCurrentBalance(asOfDateISO)`, `njNextOpenMonth()`, `njLinePool()`, `njStatementPeriodLabel(st)`, `saveNJDraft()`, `finalizeNJStatement()`, `recordNJPayment(amount,receivedDate,reference,invoiceIds)`, `voidNJPayment(id)`, `voidNJStatement(id)`, `printStatement(id)` — see "Nationwide Jewellers — Statement" above
- `PGL_LOGO_B64` — shared base64 logo constant, used by both `printInvoice()` and `printStatement()` (extracted from `printInvoice()` so the ~32KB payload isn't duplicated)

**IDs:** `Date.now().toString(36) + Math.random().toString(36).slice(2,7)` via `gid()`

---

## Workflow
1. Build/test in dev file against dev Supabase
2. Once tested, copy to index.html swapping only SB_URL, SB_KEY, title — push to `dev` branch on GitHub
3. Merge `dev` → `main` for production release
4. GitHub Pages deploys ~2 min from `main`
5. DB changes: dev SQL first, verify, then prod

---

## Admin Section (partially built)

A restricted-access admin area for complex operations not safe to expose in the main UI. Not yet gated to admin-only users — anyone signed in can currently reach it.

**NJ Statement Reconciliation — built, two cards.** "NJ Statements" lists finalized statements with Void only (reverses billing, releases everything, refuses rather than guessing if the statement's credit note has already been used downstream). "NJ Payments" lists recorded payments with a "Record Payment" action (tick any unpaid invoice, enter amount, credit note auto-calculated as the difference) and per-row Void. See "Nationwide Jewellers — Statement" above for full detail.

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
- RLS policies on the remaining unverified tables (`items`, `job_types`, `sub_customers`, `shipping_runs`, `billing_runs`, `retailers`, `billing_statuses`, `nj_statements`, `nj_statement_lines`, `nj_credit_notes`) — see the "Security note" under Authentication for which tables are already confirmed secured vs. not, and how to check the rest directly rather than assuming
- CSV matching Solo accounting import
- Records page: shipped/unshipped filter (deferred — spacing constraints)
- Sub-customer address entry UI (currently populated directly in Supabase)
- **Invoice edit / void screen** — this is about individual `tax_invoices` (INV-XXXX), distinct from the statement-level void that's now built. View a specific invoice's packets, remove items (sets `packets.shipping_run_id = null`), void (`tax_invoices.status = 'void'`), and reissue with a new INV number. Data model already supports this. Required to enforce the one-invoice-per-packet rule when correcting a shipping/invoicing error (as opposed to a whole-statement error, which Void in Admin now handles).
- **Invoice search** — Search by INV number, sub-customer, date, amount.
- ~~NJ billing reconciliation~~ — done, via NJ Statement History + Admin (see "Nationwide Jewellers — Statement" above).
- **Alexandra / Queenstown billing review** — Manual test pass: verify Step 2 modal and PDF generation are correct under the unified billing model (no shipping, unaffected by tax_invoices change).
- **Voiding an already-Paid NJ statement whose credit note is already used elsewhere** — `voidNJStatement()` currently refuses this case outright rather than unwinding it automatically; needs a real design before it's more than a safe refusal.

## Split Reconciliation

~~Future Reports — Split Reconciliation~~ — done, via **Nationwide Monthly Split (CSV)** (see "Views / Screens" above), rather than the two separate reports originally sketched here. That CSV sidesteps the "which formula is correct" question below by showing Paula's raw share *and* her actual (discounted) share side by side on every row, so the gap is visible directly instead of the report having to pick one.

**Still open, not fixed:** `buildInvoiceSummary()` — what Paula actually gets invoiced through the Run Billing wizard — still applies the NJ discount *before* splitting by `paula_pct`, undercutting her share by the discount amount on every NJ packet (only visible for NJ, since every other retailer has `discount_pct=0`). Per Gabby, Paula is effectively a subcontractor and should bill `paula_pct` of the *raw* cost — the discount is Gabby's margin to absorb, not Paula's to share. See `CLAUDE.md` rule 21.
