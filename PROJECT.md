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
- Auth: None yet - user toggle in nav (Paula / Gabby)
- RLS enabled with open policies (no auth yet)

## Environments

| | Production | Dev |
|---|---|---|
| File | index.html (on GitHub) | AppraisalTracker-dev.html (local Desktop only) |
| Access | GitHub Pages live URL | Open file directly in browser |
| Supabase URL | https://ytmyfarsptkezxkgpcbo.supabase.co | https://xwripwrfqdddfomzfjaq.supabase.co |
| Supabase Key | sb_publishable_2POAMJdA5U1FPSgxzDy1oA_EfCnF6I2 | sb_publishable_FktRKmVGhdS5SzeJ7g6phQ_n9m4iDcm |
| Browser tab | "Billing Tracker" | "Billing Tracker [DEV]" |
| Data | Real production data | Empty - safe to break |

Only difference between the two files: the SB_URL and SB_KEY constants + the title tag.

To create a dev version: swap the two constants at the top of the script block and change the title tag to "Billing Tracker [DEV]".

## Database Schema

All lookup tables maintained directly in Supabase.

### billing_statuses (lookup)
id SERIAL PK, name TEXT, show_in_dashboard BOOLEAN, show_in_reports BOOLEAN
Values: New (1), Hold from Billing (2), Billed (3, Archived (4, hidden from dashboard/reports)
Always use name in the UI. IDs are system-only.

### retailers (lookup)
id SERIAL PK, name TEXT, code INTEGER (e.g. 1 displays as "001")
Values: Alexandra (1), Queenstown (2)

### items (lookup)
name TEXT PK - WARNING: no id column. Never sort with order=id.asc.

### job_types (lookup)
id SERIAL PK, name TEXT, cost DECIMAL(10,2)

### packets
id TEXT PK (client-generated), date TEXT (DD MMM YYYY), retailer_id FK, customer_ref TEXT, surname TEXT, status_id FK, created/modified TEXT

### packet_items
id TEXT PK, packet_id FK, item TEXT, job_type_id FK, cost DECIMAL, paula_pct INTEGER, gabrielle_pct INTEGER (must sum to 100)

### billing_runs
id TEXT PK, run_date TEXT, user_name TEXT, retailer_ids TEXT (comma-separated), packet_ids TEXT (comma-separated), status TEXT, created TEXT

### appraisals - legacy, not written to

## Key Concepts

Customer reference: Stored as 001-12345. Retailer auto-fills 3-digit prefix; user types 4-5 digit suffix.
Cost split: Calculated on the fly. packetCosts(id) returns {total, paula, gabby}.
Financial year: 1 April - 31 March (NZ).
Users: Gabby (default, sage #5C7A6B) - Paula (plum #6E4B5E).
Non-critical tables: packet_items and billing_runs load in separate try/catch so failures don't block boot.

## Views / Screens

Dashboard: Greeting + New Work Packet button - 3 stat cards (New/Hold from Billing/Billed) - pipeline placeholder - recent packets - retailer sidebar

Records: Filter bar (status/retailer/user/date range/search) - cost column - batch status update - CSV export

New/Edit Work Packet: Sticky header with split Save button - Packet Details (Date/Retailer/Ref/Surname) - Items (up to 3 cards: Item/Job Type/Cost/Split slider) - client-side validation only

Run Billing (4 steps):
1. Selection: filter + pre-checked items table - Start button
2. Retailer modal loop: items table + invoice summary (job types, GST 15%, total) per retailer - Back/Next/Generate PDFs
3. Generate PDFs: preview + download per retailer via jsPDF - Confirm + Mark as Billed
4. Confirm: marks packets as Billed, saves billing run

Reports: List of billing runs - regenerate PDFs - delete run

## Design System
Fonts: Playfair Display (headings) - Outfit (UI) - DM Mono (refs/costs)
Colours: Deep #2C2422 (nav) - Gold #B8963E (CTAs) - Plum #6E4B5E (Paula/Alexandra) - Sage #5C7A6B (Gabby/Billed) - Ember #B85C38 (Queenstown/errors) - Sky #4A7A9B (New status)
-light suffix variants for backgrounds/badges.

## Code Conventions

State: S object - packets, allPacketItems, billingStatuses, retailers, jobTypes, items, editItems, recFilters, selectedPacketIds, billing, billingRuns, user, view
Render: render() rebuilds entire DOM. renderAsync() pre-fetches edit data. Never call from inside a form.
Toast: toast() calls render() - never inside forms. Use showToast() instead.
Supabase helpers: sbAll, sbInsert, sbUpdate, sbDelete, sbUpsert, fetchPacketItems(id)
Key helpers: fmtD, dateToISO, parseStoredDate, pad3, fmtMoney, packetCosts, getBillingItems, buildInvoiceSummary, statusName, statusId, statusBadgeStyle, statusShowDash
IDs: Client-generated - Date.now().toString(36) + random

## Workflow

Making changes:
1. Build and test in AppraisalTracker-dev.html against dev Supabase
2. Claude provides updated AppraisalTracker.html (production credentials)
3. Claude Code: "Replace index.html with downloaded file and push to GitHub"
4. GitHub Pages deploys in ~2 minutes
5. DB schema changes: run SQL in both Supabase projects (dev first, then prod)

## Planned Features
- Billing pipeline workflow (status changes from dashboard)
- CSV format matching Solo accounting import
- Proper auth (replace user toggle)

## Learnings & Bug Prevention

Read this before making any changes.

### Rule 1 - Variable declaration order (const/let hoisting)
const and let are NOT hoisted. Referencing before declaration throws ReferenceError - blank screen.
Hit us with: addItemBtn, saveBtn, selCount all declared after code that referenced them.
Rule: Declare variables before any function or code that references them.

### Rule 2 - Never trigger render() from inside a form
render() rebuilds entire DOM, wiping draft state. toast() also calls render() twice.
Symptoms: form resets on Save, item cards disappear on validation error.
Rule: Form validation must only manipulate existing DOM elements. Use showToast() for feedback. Use renderAsync() after save.

### Rule 3 - Non-critical Supabase tables must load separately
A throw in loadAll()'s main try block aborts boot before S.ready=true - permanent spinner.
Rule: Load packet_items and billing_runs in their own try/catch blocks.

### Rule 4 - Never assume a Supabase table has an id column
items PK is name. Using order=id.asc throws 42703 column does not exist.
Rule: Every sbAll call specifies its own explicit order param.

### Rule 5 - No non-ASCII characters in JavaScript
Non-ASCII chars cause SyntaxError - app shows loading spinner.
Avoid: unicode arrows, box-drawing, em-dashes, middle dots, literal newlines in strings.
Use: ->, --, -, // ===, \\n in Python-generated strings.
After Python codegen: scan script block for non-ASCII before delivering.

### Rule 6 - Never disable primary action buttons
Use showToast() inside the click handler for empty state instead.

### Rule 7 - Blank screen = browser console first
Right-click -> Inspect -> Console.

### Pre-delivery checklist
- No const/let variable referenced before its declaration in the same scope
- No render() or toast() called inside a form validation or error handler
- Non-critical Supabase tables loaded in separate try/catch blocks
- No non-ASCII characters in the script block
- No literal newlines inside JS string literals
- No duplicate variable declarations in same scope
- Primary action buttons are not disabled - handle empty state in click handler
