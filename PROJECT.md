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

To create a dev version: swap SB_URL, SB_KEY constants and title tag. That's the only difference.

---

## Database Schema

All lookup tables maintained directly in Supabase - no in-app editing.

### users
| Column | Type | Notes |
|---|---|---|
| id | SERIAL PK | |
| name | TEXT | "Gabby", "Paula" |
| slug | TEXT UNIQUE | "gabby", "paula" - used in code and billing_runs |
| colour | TEXT | Hex colour for UI |
| gst_registered | BOOLEAN | Gabby=true, Paula=false |
| gst_rate | DECIMAL(5,2) | Gabby=15.00, Paula=0.00 |
| income_tax_rate | DECIMAL(5,2) | Gabby=33.00, Paula=17.50 |
| active | BOOLEAN | Controls nav toggle visibility |

Nav toggle built dynamically from active users. Falls back to hardcoded Gabby/Paula if table not loaded.

### billing_statuses (lookup)
id, name, show_in_dashboard BOOLEAN, show_in_reports BOOLEAN
Values: New (1), Hold from Billing (2), Billed (3), Archived (4 - hidden everywhere)
Always use name in UI. IDs are system-only.

### retailers (lookup)
id, name, code INTEGER (e.g. 1 displays as "001")
Values: Alexandra (1), Queenstown (2)

### items (lookup)
name TEXT PK - WARNING: no id column. Never sort with order=id.asc.

### job_types (lookup)
id, name, cost DECIMAL(10,2)

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

**Per-user billing flags:** packets.paula_billed and packets.gabby_billed track each user independently. When Paula bills, only paula_billed is set. When both are true (or one user has 0% work), status_id is set to Billed automatically.

**Billing status display:** packetBillingLabel(pkt) returns "Billed (Paula)", "Billed (Gabby)", "Fully Billed" based on flags - overrides status_id in the UI.

**GST:** Conditional per user. Gabby is GST registered (15%). Paula is not (no GST line on reports). Both rates stored in users table - change in Supabase, no code needed.

**Financial year:** 1 April - 31 March (NZ).

**Users:** Loaded from users table. getCurrentUser() returns full user row with fallback to hardcoded values.

**Non-critical table loading:** packet_items, billing_runs, users all load in separate try/catch blocks so failures don't block boot.

---

## Views / Screens

### Dashboard
- Greeting + "New Work Packet" button
- 3 dollar cards (current user's share only): Unbilled / Earned This Week / Earned This Month
  - Unbilled: excludes Hold from Billing and Archived, not yet billed by this user
  - Earned This Week/Month: includes billed AND unbilled work, excludes Hold and Archived
- 4 status count cards (smaller, secondary): New / On Hold / Part Billed / Fully Billed
- Recent packets table (last 5) + Retailer breakdown sidebar

### Records
- Filter bar: Status pills, Retailer, User (All/Paula/Gabby), Date range (presets + custom), Search, Reset
- Cost column (Total/Paula/Gabby based on User filter)
- Batch status update toolbar
- CSV export of filtered results (includes cost split columns)

### New / Edit Work Packet
- Sticky header: Cancel + split Save button (Save = stays in edit mode, Save and Add New = fresh form)
- Packet Details: Date, Retailer + Ref (auto-prefix), Surname
- Items (up to 3 cards): Item, Job Type (sets cost), Cost ($), Split slider (drag right = Gabby increases, 5% steps, defaults to 100% active user)
- Client-side validation only - never re-renders on failure
- Edit mode: renderAsync() pre-fetches packet_items before rendering

### Run Billing (4 steps)
1. Selection: filter by status/date, pre-checked packet_items table (excludes Hold/Archived/already billed by this user, excludes items where user has 0%). Start button.
2. Retailer modal loop (one per retailer): items table + invoice summary (Job Types, user cost, subtotal, GST if registered, total). Back/Next/Generate PDFs.
3. Generate PDFs: preview + download per retailer (jsPDF, portrait A4). Download All. Confirm + Mark as Billed.
4. Confirm: marks paula_billed or gabby_billed = true per packet. Auto-sets status to Billed if other user also done (or has 0% work). Saves billing run.

### Reports
List of billing runs - regenerate PDFs - delete run

---

## Design System
Fonts: Playfair Display (headings) - Outfit (UI) - DM Mono (refs/costs)
Colours: Deep #2C2422 (nav) - Gold #B8963E (CTAs) - Plum #6E4B5E (Paula/Alexandra) - Sage #5C7A6B (Gabby/Billed) - Ember #B85C38 (Queenstown/errors) - Sky #4A7A9B (New status). All stored in users table per user. -light suffix variants for backgrounds/badges.

---

## Code Conventions

State (S object): packets, allPacketItems, billingStatuses, users, retailers, jobTypes, items, editItems, recFilters, selectedPacketIds, billing, billingRuns, user (slug), view

Render: render() rebuilds entire DOM. renderAsync() pre-fetches edit data first. Never call from inside a form or validation.

Toast: toast() calls render() - never inside forms. Use showToast() (direct DOM inject).

Supabase helpers: sbAll, sbInsert, sbUpdate, sbDelete, sbUpsert, fetchPacketItems(id)

Key helpers:
- getCurrentUser() - full user row with fallback defaults
- getDollarStats() - {unbilled, earnedWeek, earnedMonth} for current user
- packetCosts(id) - {total, paula, gabby} from allPacketItems
- packetBillingLabel(pkt) - computed display status from billed flags
- userHasBilled(pkt), userHasNoWork(pktId) - per-user billing checks
- getBillingItems() - filtered packet_items for Run Billing step 1
- buildInvoiceSummary(items, retailerId) - job type totals for invoice modal
- fmtD(d), dateToISO(s), parseStoredDate(s), pad3(n), fmtMoney(n)
- statusName(id), statusId(name), statusBadgeStyle(name), statusShowDash(id)

IDs: Client-generated - Date.now().toString(36) + random

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
Rule: Load packet_items, billing_runs, users in their own try/catch blocks.
```js
try { S.users = await sbAll('users', ...); }
catch(e) { console.warn('users failed:', e); S.users = []; }
```

### Rule 4 - Never assume a Supabase table has an id column
items PK is name. Using order=id.asc throws 42703 column does not exist.
Rule: Every sbAll call specifies its own explicit order param.

### Rule 5 - No non-ASCII characters in JavaScript
Non-ASCII chars = SyntaxError = loading spinner.
Use: -> not arrows, -- not em-dashes, - not middle dots, // === not box-drawing, \\n not literal newlines in Python strings.
After Python codegen: scan script block for non-ASCII before delivering.

### Rule 6 - Never disable primary action buttons
Handle empty state in the click handler with showToast() instead.

### Rule 7 - Blank screen = browser console first
Right-click -> Inspect -> Console.

### Rule 8 - Auto-select must only fire when Set is empty
If auto-select fires on every render it re-adds deselected items, making checkboxes non-functional.
Rule: Auto-select condition must be selectedItemIds.size===0 only.
Reset the Set explicitly (e.g. on user toggle change) to trigger a fresh auto-select.

### Pre-delivery checklist
- [ ] No const/let referenced before declaration in same scope
- [ ] No render() or toast() inside form validation
- [ ] Non-critical tables in separate try/catch
- [ ] No non-ASCII in script block
- [ ] No literal newlines in JS strings
- [ ] No duplicate variable declarations in same scope
- [ ] Primary buttons not disabled - handle empty state in click handler
- [ ] Auto-select only fires when Set is empty
