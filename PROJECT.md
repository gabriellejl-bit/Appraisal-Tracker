# Billing Tracker - Project Context

## Purpose
A billing tracker for jewellery appraisal work. Paula and Gabby perform valuations for jewellery retailers and track work for invoicing. Each job is identified by the retailer's POS reference number. Retailer is the primary billing entity - Paula and Gabby invoice each retailer separately based on their work split percentage.

## URLs
- Live: https://gabriellejl-bit.github.io/Appraisal-Tracker/
- Repo: https://github.com/gabriellejl-bit/Appraisal-Tracker

## Stack
- Frontend: Single HTML file (index.html) - vanilla JS, no framework
- Database: Supabase (PostgreSQL) via REST API - no SDK, raw fetch
- Hosting: GitHub Pages
- Auth: None yet - user toggle in nav. Email/password via Supabase Auth planned.
- RLS enabled with open policies (no auth yet)

## Environments

| | Production | Dev |
|---|---|---|
| File | index.html (on GitHub) | AppraisalTracker-dev.html (local only, never committed) |
| Supabase URL | https://ytmyfarsptkezxkgpcbo.supabase.co | https://xwripwrfqdddfomzfjaq.supabase.co |
| Supabase Key | sb_publishable_2POAMJdA5U1FPSgxzDy1oA_EfCnF6I2 | sb_publishable_FktRKmVGhdS5SzeJ7g6phQ_n9m4iDcm |
| Browser tab | "Billing Tracker" | "Billing Tracker [DEV]" |
| Data | Real production data | Safe to break |

Only difference between files: SB_URL, SB_KEY constants and title tag.

---

## Database Schema

### users
id SERIAL PK, name TEXT, slug TEXT UNIQUE, colour TEXT, gst_registered BOOLEAN, gst_rate DECIMAL(5,2), income_tax_rate DECIMAL(5,2), active BOOLEAN
- Gabby: slug=gabby, colour=#5C7A6B, gst_registered=true, gst_rate=15, income_tax_rate=33
- Paula: slug=paula, colour=#6E4B5E, gst_registered=false, gst_rate=0, income_tax_rate=17.5
- Nav toggle built dynamically from active users. Falls back to hardcoded if table not loaded.

### billing_statuses (lookup)
id, name, show_in_dashboard BOOLEAN, show_in_reports BOOLEAN
Values: New (1), Hold from Billing (2), Billed (3), Archived (4 - hidden everywhere)
Always use name in UI. IDs are system-only. "Billed" is auto-managed only - never set manually.

### retailers (lookup)
id, name, code INTEGER (displays as "001")
Values: Alexandra (1), Queenstown (2)

### items (lookup)
name TEXT PK, display_order INTEGER
WARNING: PK is name - no id column. Never sort with order=id.asc.
Sort by: &order=display_order.asc

### job_types (lookup)
id, name, cost DECIMAL(10,2), display_order INTEGER
Sort by: &order=display_order.asc

### packets
id TEXT PK (client-generated), date TEXT (DD MMM YYYY), retailer_id FK, customer_ref TEXT (e.g. "001-12345"), surname TEXT, status_id FK -> billing_statuses, paula_billed BOOLEAN, gabby_billed BOOLEAN, created/modified TEXT

### packet_items
id TEXT PK, packet_id FK, item TEXT, job_type_id FK, cost DECIMAL, paula_pct INTEGER, gabrielle_pct INTEGER (must sum to 100)

### billing_runs
id TEXT PK, run_date TEXT, user_name TEXT (slug), retailer_ids TEXT (comma-separated), packet_ids TEXT (comma-separated), status TEXT, created TEXT

### appraisals - legacy, not written to

---

## Key Concepts

**Customer reference:** Stored as "001-12345". Retailer auto-fills 3-digit prefix; user types 4-5 digit suffix.

**Cost split:** Calculated on the fly - never stored. packetCosts(id) returns {total, paula, gabby}.

**Per-user billing flags:** paula_billed and gabby_billed track each user independently. When both true (or one user has 0% work on all items), status_id is auto-set to Billed. "Billed" status is never set manually.

**Billing status display:** packetBillingLabel(pkt) returns "Billed (Paula)", "Billed (Gabby)", "Fully Billed" - overrides status_id in UI badges.

**Workflow statuses (user-selectable):** New, Hold from Billing, Archived. Hold freezes billing toggles but allows editing packet details/items. Archived freezes billing toggles.

**GST:** Conditional per user from users table. Gabby: subtotal + GST (15%) + Total. Paula: subtotal + Total only. Rate stored in users table - change in Supabase, no code needed.

**Financial year:** 1 April - 31 March (NZ).

**Non-critical table loading:** users, packet_items, billing_runs load in separate try/catch - failures don't block boot.

**Falsy trap:** Never use || for numeric defaults where 0 is a valid value. Use != null check instead.
e.g. row.gabrielle_pct != null ? row.gabrielle_pct : 100 (not row.gabrielle_pct || 100)

---

## Views / Screens

### Dashboard
- Greeting + "New Work Packet" button
- 3 dollar cards (current user's share): Unbilled / Earned This Week / Earned This Month
  - Unbilled: excludes Hold and Archived, not yet billed by this user
  - Earned This Week/Month: includes billed AND unbilled, excludes Hold and Archived
- 4 status count cards (smaller): New / On Hold / Part Billed / Fully Billed
- Recent packets table (last 5) - whole row clickable to edit
- Retailer breakdown sidebar

### Records
- Filter bar: Status pills, Retailer, User (All/Paula/Gabby), Date range (presets + custom), Search, Reset
- Cost column (Total/Paula/Gabby based on User filter)
- Whole row clickable to edit. Checkbox stops propagation (doesn't trigger row click).
- Batch status update toolbar
- CSV export of filtered results (includes cost split columns)

### New / Edit Work Packet
- Sticky header: title + computed status badge (edit mode) + Cancel + split Save button
- **Edit mode only - Billing Status card (above Packet Details):**
  - Workflow lozenges: New / Hold / Archived (immediate save, Hold disabled if either user billed)
  - Clicking New resets both billed flags to false
  - Billing toggles: "Paula: Billed/Unbilled" and "Gabby: Billed/Unbilled" (immediate save, disabled when Hold or Archived)
  - Fully Billed warning shown inline when both users billed
  - Delete packet button (confirmation prompt, deletes packet_items then packet)
- Packet Details: Date, Retailer + Ref (auto-prefix), Surname
- Items (up to 3 cards): Item (ordered by display_order), Job Type (ordered by display_order), Cost ($), Split slider (drag right = Gabby increases, 5% steps)
  - Item trash icon: always visible in edit mode, deletes from packet_items immediately
- Client-side validation only - never re-renders on failure
- Edit mode: renderAsync() pre-fetches packet_items. gabrielle_pct=0 loads correctly (not defaulted to 100).

### Run Billing (4 steps)
1. Selection: filter by status/date, pre-checked items (excludes Hold/Archived/already billed by this user, excludes 0% items). Start button. Uses initialised flag for auto-select (not Set.size).
2. Retailer modal loop: items table + invoice summary (Job Types, user cost, subtotal, GST if registered, total). Back/Next/Generate PDFs.
3. Generate PDFs: preview + download per retailer (jsPDF, portrait A4). Download All. Confirm + Mark as Billed.
4. Confirm: sets paula_billed or gabby_billed = true. Auto-sets status to Billed if other user done or has 0% work. Saves billing run.

### Reports
List of billing runs - regenerate PDFs - delete run

---

## Design System
Fonts: Playfair Display (headings) - Outfit (UI) - DM Mono (refs/costs)
Colours stored in users table per user.
Deep #2C2422 (nav) - Gold #B8963E (CTAs) - Plum #6E4B5E (Paula/Alexandra) - Sage #5C7A6B (Gabby/Billed) - Ember #B85C38 (errors) - Sky #4A7A9B (New status)
-light suffix variants for backgrounds/badges.

---

## Code Conventions

State (S object): packets, allPacketItems, billingStatuses, users, retailers, jobTypes, items, editItems, recFilters, selectedPacketIds, billing (incl. initialised flag), billingRuns, user (slug), view

Render: render() rebuilds entire DOM. renderAsync() pre-fetches edit data. Never call from inside a form.

Toast: toast() calls render() - never inside forms. Use showToast() (direct DOM inject).

Supabase helpers: sbAll, sbInsert, sbUpdate, sbDelete, sbUpsert, fetchPacketItems(id)

Key helpers:
- getCurrentUser() - full user row with fallback defaults (call once per function, not cu2/cu3/cu4)
- getDollarStats() - {unbilled, earnedWeek, earnedMonth} for current user
- packetCosts(id) - {total, paula, gabby} from allPacketItems
- packetBillingLabel(pkt) - "Billed (Paula)" / "Billed (Gabby)" / "Fully Billed" / null
- userHasBilled(pkt), userHasNoWork(pktId)
- getBillingItems() - filtered items for Run Billing step 1
- buildInvoiceSummary(items, retailerId) - job type totals for invoice modal
- fmtD(d), dateToISO(s), parseStoredDate(s), pad3(n), fmtMoney(n)
- statusName(id), statusId(name), statusBadgeStyle(name), statusShowDash(id)

IDs: Client-generated - Date.now().toString(36) + random

Known refactor debt (non-urgent):
- Some render functions still use inline user ternaries instead of getCurrentUser()
- cu2/cu3/cu4 in billing report should be one getCurrentUser() call at top
- otherPctField mapping in billing flags could be derived from users table

---

## Workflow

1. Build and test in AppraisalTracker-dev.html against dev Supabase
2. When happy, swap credentials to prod and provide AppraisalTracker.html
3. Claude Code: "Replace index.html with downloaded file and push to GitHub"
4. GitHub Pages deploys in ~2 minutes
5. DB schema changes: run SQL in dev first, then prod

---

## Planned Features
- Proper auth (email/password via Supabase Auth)
- CSV format matching Solo accounting import
- Billing pipeline workflow (status changes from dashboard)
- Refactor: consolidate getCurrentUser() calls, clean up cu2/cu3/cu4

---

## Learnings & Bug Prevention

Read before making any changes.

### Rule 1 - Variable declaration order (const/let hoisting)
const and let are NOT hoisted. Referencing before declaration = ReferenceError = blank screen.
Hit us repeatedly: addItemBtn, saveBtn, selCount all declared after code that used them.
Rule: Declare variables before any function or code that references them.

### Rule 2 - Never trigger render() from inside a form
render() wipes entire DOM including draft form state. toast() also calls render() twice.
Rule: Form validation must only manipulate existing DOM elements. Use showToast(). Use renderAsync() after save.

### Rule 3 - Non-critical Supabase tables must load separately
Any throw in loadAll()'s main try block aborts boot before S.ready=true = permanent spinner.
Rule: Load users, packet_items, billing_runs in their own try/catch blocks.

### Rule 4 - Never assume a Supabase table has an id column
items PK is name. Using order=id.asc throws 42703 column does not exist.
Rule: Every sbAll call specifies its own explicit order param.

### Rule 5 - No non-ASCII characters in JavaScript
Non-ASCII chars = SyntaxError = loading spinner.
Use: -> not arrows, -- not em-dashes, - not middle dots, // === not box-drawing, \\n not literal newlines.
After Python codegen: scan script block for non-ASCII before delivering.

### Rule 6 - Never disable primary action buttons
Handle empty state in click handler with showToast() instead.

### Rule 7 - Blank screen = browser console first
Right-click -> Inspect -> Console.

### Rule 8 - Auto-select must use an initialised flag, not Set.size
Set.size===0 re-triggers auto-select when user unchecks all items, making checkboxes non-functional.
Rule: Use an explicit b.initialised flag. Reset it when context changes (user toggle, nav click).

### Rule 9 - Never use || for numeric defaults where 0 is valid
row.gabrielle_pct || 100 treats 0 as falsy, defaulting 100% Paula items to 100% Gabby on load.
Rule: Use explicit null check: row.gabrielle_pct != null ? row.gabrielle_pct : 100

### Rule 10 - stopPropagation on nested interactive elements in clickable rows
When a table row has an onClick, nested buttons and checkboxes must call e.stopPropagation()
to prevent the row click from firing when the user interacts with them.

### Pre-delivery checklist
- [ ] No const/let referenced before declaration in same scope
- [ ] No render() or toast() inside form validation
- [ ] Non-critical tables in separate try/catch
- [ ] No non-ASCII in script block
- [ ] No literal newlines in JS strings
- [ ] No duplicate variable declarations in same scope
- [ ] Primary buttons not disabled - handle empty state in click handler
- [ ] Auto-select uses initialised flag not Set.size
- [ ] Numeric defaults use != null not ||
- [ ] Nested interactive elements in clickable rows have stopPropagation
