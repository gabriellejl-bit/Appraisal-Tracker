# Billing Tracker - Project Context

## Purpose
Billing tracker for jewellery appraisal work. Paula and Gabby invoice jewellery retailers separately based on their work split percentage per job.

## URLs
- Live: https://gabriellejl-bit.github.io/Appraisal-Tracker/
- Repo: https://github.com/gabriellejl-bit/Appraisal-Tracker

## Stack
- Frontend: Single HTML file (index.html) - vanilla JS, no framework
- Database: Supabase (PostgreSQL) via REST API - no SDK, raw fetch
- Hosting: GitHub Pages
- Auth: None yet - user toggle in nav. Supabase email/password planned.
- RLS enabled with open policies (no auth yet)

## Environments

| | Production | Dev |
|---|---|---|
| File | index.html (GitHub) | AppraisalTracker-dev.html (local only, never committed) |
| Supabase URL | https://ytmyfarsptkezxkgpcbo.supabase.co | https://xwripwrfqdddfomzfjaq.supabase.co |
| Supabase Key | sb_publishable_2POAMJdA5U1FPSgxzDy1oA_EfCnF6I2 | sb_publishable_FktRKmVGhdS5SzeJ7g6phQ_n9m4iDcm |
| Browser tab | "Billing Tracker" | "Billing Tracker [DEV]" |

Only difference between files: SB_URL, SB_KEY, title tag. Dev is always ahead of or equal to prod.

Download production file: open in browser, File -> Save Page As (Cmd+S on Mac).

---

## Database Schema

### users
id, name, slug (UNIQUE), colour, gst_registered, gst_rate DECIMAL, income_tax_rate DECIMAL, active
- Gabby: gabby, #5C7A6B, GST registered 15%, income tax 33%
- Paula: paula, #6E4B5E, not GST registered, income tax 17.5%
- Nav toggle built from active users. Falls back to hardcoded if not loaded.

### billing_statuses (lookup)
id, name, show_in_dashboard, show_in_reports
Values: New (1), Hold from Billing (2), Billed (3), Archived (4 - hidden everywhere)
Always use name in UI. "Billed" is auto-managed only - never set manually.

### retailers (lookup)
id, name, code INTEGER (displays as "001"). Values: Alexandra (1), Queenstown (2)

### items (lookup)
name TEXT PK, display_order INTEGER
WARNING: no id column. Never sort with order=id.asc. Sort: &order=display_order.asc

### job_types (lookup)
id, name, cost DECIMAL, display_order INTEGER. Sort: &order=display_order.asc

### packets
id TEXT PK, date TEXT (DD MMM YYYY), retailer_id FK, customer_ref TEXT, surname TEXT, status_id FK, paula_billed BOOLEAN, gabby_billed BOOLEAN, created/modified TEXT

### packet_items
id TEXT PK, packet_id FK, item TEXT, job_type_id FK, cost DECIMAL, paula_pct INTEGER, gabrielle_pct INTEGER (sum to 100)

### billing_runs
id TEXT PK, run_date TEXT, user_name TEXT (slug), retailer_ids TEXT (csv), packet_ids TEXT (csv), status TEXT, created TEXT

### appraisals - legacy, not written to

---

## Key Concepts

**Cost split:** Calculated on the fly. packetCosts(id) returns {total, paula, gabby}.

**Per-user billing:** paula_billed/gabby_billed track independently. When both true (or one user has 0% on all items), status_id auto-sets to Billed. Never set Billed manually.

**Billing display:** packetBillingLabel(pkt) returns "Billed (Paula)", "Billed (Gabby)", "Fully Billed", or null. Also returns "Fully Billed" when one user has billed and the other has 0% on all items.

**Workflow statuses:** New, Hold from Billing, Archived. Hold freezes billing toggles but allows editing details/items. Archived freezes billing toggles.

**GST:** Conditional per user. Gabby: subtotal + GST + Total. Paula: subtotal + Total only. Rates from users table.

**Financial year:** 1 April - 31 March (NZ).

**Non-critical loading:** users, packet_items, billing_runs in separate try/catch - failures don't block boot.

**Falsy trap:** Use != null for numeric defaults where 0 is valid. e.g. row.gabrielle_pct != null ? row.gabrielle_pct : 100

---

## Nav Structure
Centre: Dashboard - Records - Run Billing ($icon) - Reports
Right: [User toggle] [+ New Packet] (gold button) [Connected dot]
Reports nav stays active for: reports, billingRunsReport, customerReport views.

## Views / Screens

### Dashboard
- 3 dollar cards (user share): Unbilled / Earned This Week / Earned This Month
  - Unbilled: excludes Hold and Archived, not yet billed by this user
  - Week/Month: includes billed + unbilled, excludes Hold and Archived
- 4 status count cards: New / On Hold / Part Billed / Fully Billed
- Recent packets (last 5) - whole row clickable to edit
- Quick Actions: Search Records + Run Billing
- By Retailer bar chart (this month only, excludes Archived)

### Records
- Filters: Status pills, Retailer, User, Date range, Search, Reset
- Cost column (Total/Paula/Gabby per User filter)
- Whole row clickable to edit. Checkbox stops propagation.
- Batch status update + CSV export

### New / Edit Work Packet
- Sticky header: title + status badge (edit) + Cancel + split Save button
- Edit mode - Billing Status card (above Packet Details):
  - Workflow lozenges: New / Hold / Archived (immediate save)
  - Hold disabled if either user billed. New resets both billed flags.
  - Billing toggles: Paula / Gabby (immediate save, disabled on Hold/Archived)
  - Fully Billed warning when both billed
  - Delete packet button (confirmation, deletes items then packet)
- Packet Details: Date, Retailer + Ref, Surname
- Items (up to 3): Item + Job Type (both by display_order), Cost, Split slider (right = Gabby increases)
  - Trash icon in edit mode deletes from packet_items immediately
- gabrielle_pct=0 loads correctly (not falsy-defaulted to 100)

### Run Billing (4 steps)
1. Selection: filter + pre-checked items (excludes Hold/Archived/already billed/0% items). Uses b.initialised flag.
2. Retailer modal loop: items table + invoice summary (GST conditional). Back/Next/Generate PDFs.
3. PDFs: preview + download per retailer (jsPDF A4). Confirm + Mark as Billed.
4. Confirm: sets per-user billed flags, auto-sets Billed when both done. Saves billing run.

### Reports (landing page)
Two cards: Billing Runs and Customer Report. Click to navigate with breadcrumb.

### Billing Runs (Reports > Billing Runs)
Billing run history. Regenerate PDFs. Delete run.

### Customer Report (Reports > Customer Report)
Filter: date range (defaults this month) + retailer. Groups by retailer, lists items per customer sorted by ref. Totals per retailer. Download PDF (jsPDF A4).

---

## Design System
Fonts: Playfair Display (headings) - Outfit (UI) - DM Mono (refs/costs)
Deep #2C2422 (nav) - Gold #B8963E (CTAs) - Plum #6E4B5E (Paula/Alexandra) - Sage #5C7A6B (Gabby/Billed) - Ember #B85C38 (errors) - Sky #4A7A9B (New). -light variants for badges.
Icons: I object with SVG strings. Key: home, list, dollar, save, plus, download, edit, trash, search, back, refresh, check, alert, inbox, calendar, arrow, close, empty.

---

## Code Conventions

**State (S):** packets, allPacketItems, billingStatuses, users, retailers, jobTypes, items, editItems, recFilters, selectedPacketIds, billing (incl. initialised), billingRuns, customerReport, user (slug), view

**Render:** render() = full DOM rebuild. renderAsync() = pre-fetches edit data first. Never call from inside a form.

**Toast:** toast() calls render() - never inside forms. Use showToast() (direct DOM inject, safe anywhere).

**Supabase:** sbAll, sbInsert, sbUpdate, sbDelete, sbUpsert, fetchPacketItems(id)

**Key helpers:**
- getCurrentUser() - full user row, call once per function (not cu2/cu3/cu4)
- getDollarStats() - {unbilled, earnedWeek, earnedMonth}
- packetCosts(id), packetBillingLabel(pkt), userHasBilled(pkt), userHasNoWork(pktId)
- getBillingItems(), buildInvoiceSummary(items, retailerId)
- renderBreadcrumb(section), renderBillingRunsReport(), renderCustomerReportPage()
- downloadCustomerReportPDF(packets, filters)
- fmtD(d), dateToISO(s), parseStoredDate(s), getDateRange(key), pad3(n), fmtMoney(n)
- statusName(id), statusId(name), statusBadgeStyle(name), statusShowDash(id)

**IDs:** Date.now().toString(36) + random

**Refactor debt:** inline user ternaries should use getCurrentUser(); cu2/cu3/cu4 in billing report should be one call.

---

## Workflow
1. Build/test in dev file against dev Supabase
2. Swap credentials -> provide AppraisalTracker.html
3. Download: File -> Save Page As (Cmd+S)
4. Claude Code: "Replace index.html with downloaded file and push to GitHub"
5. GitHub Pages deploys ~2 min. One branch (main) only.
6. DB changes: dev SQL first, then prod

---

## Planned Features
- Proper auth (Supabase email/password)
- CSV matching Solo accounting import
- Refactor: consolidate getCurrentUser() calls

---

## Learnings & Bug Prevention

### Rule 1 - Variable declaration order
const/let not hoisted. Reference before declaration = blank screen.
Declare variables before any function that uses them.

### Rule 2 - Never render() from inside a form
Wipes all draft state. toast() also calls render() twice.
Use showToast() for feedback. Use renderAsync() after save.

### Rule 3 - Non-critical tables load separately
Throw in main loadAll() try block = permanent spinner.
users, packet_items, billing_runs each in own try/catch.

### Rule 4 - Never assume a table has an id column
items PK is name. order=id.asc throws 42703.
Every sbAll specifies its own order param.

### Rule 5 - No non-ASCII in JavaScript
Causes SyntaxError = spinner. Use ASCII only in JS.
After Python codegen: scan script block before delivering.

### Rule 6 - Never disable primary buttons
Use showToast() in click handler for empty state.

### Rule 7 - Blank screen = browser console first
Right-click -> Inspect -> Console.

### Rule 8 - Auto-select uses initialised flag not Set.size
Set.size===0 re-triggers when user unchecks all.
Use b.initialised flag. Reset on context change.

### Rule 9 - Never use || for 0-valid numeric defaults
Use: value != null ? value : default

### Rule 10 - stopPropagation in clickable rows
Nested buttons/checkboxes must call e.stopPropagation().

### Rule 11 - Verify icon exists in I object before use
I.missingIcon renders as "undefined" in UI.
Check I object before adding any new ic() call.

### Pre-delivery checklist
- [ ] No const/let referenced before declaration
- [ ] No render()/toast() inside form validation
- [ ] Non-critical tables in separate try/catch
- [ ] No non-ASCII in script block
- [ ] No literal newlines in JS strings
- [ ] No duplicate variable declarations in same scope
- [ ] Primary buttons not disabled
- [ ] Auto-select uses b.initialised not Set.size
- [ ] Numeric defaults use != null not ||
- [ ] Nested row elements have stopPropagation
- [ ] All ic() references exist in I object
