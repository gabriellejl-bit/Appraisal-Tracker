# Billing Tracker — Project Context

## Purpose
A billing tracker for jewellery appraisal work. Paula and Gabby perform valuations for jewellery retailers and track work for invoicing. Each job is identified by the retailer's POS reference number. **Retailer is the primary billing entity** — Paula and Gabby invoice each retailer separately based on their work split percentage.

## URLs
- **Live:** https://gabriellejl-bit.github.io/Appraisal-Tracker/
- **Repo:** https://github.com/gabriellejl-bit/Appraisal-Tracker

## Stack
- **Frontend:** Single HTML file (`index.html`) — vanilla JS, no framework
- **Database:** Supabase (PostgreSQL) via REST API — no SDK, raw fetch
- **Hosting:** GitHub Pages
- **Auth:** None yet — user toggle in nav (Paula / Gabby)
- **Supabase URL:** `https://ytmyfarsptkezxkgpcbo.supabase.co`
- **Supabase Key:** `sb_publishable_2POAMJdA5U1FPSgxzDy1oA_EfCnF6I2`
- RLS enabled with open policies (no auth yet)

---

## Database Schema

All lookup tables maintained directly in Supabase — no in-app editing.

### `billing_statuses` (lookup)
| Column | Type | Notes |
|---|---|---|
| id | SERIAL PK | |
| name | TEXT | "New", "Hold from Billing", "Billed", "Archived" |
| show_in_dashboard | BOOLEAN | Archived = false |
| show_in_reports | BOOLEAN | Archived = false |

**Always use `name` in the UI. IDs are system-only.**
Statuses: New (1), Hold from Billing (2), Billed (3), Archived (4)

### `retailers` (lookup)
| Column | Type | Notes |
|---|---|---|
| id | SERIAL PK | |
| name | TEXT | "Alexandra", "Queenstown" |
| code | INTEGER | e.g. 1 displays as "001" |

### `items` (lookup)
| Column | Type | Notes |
|---|---|---|
| name | TEXT PK | e.g. "Ring", "Watch" |

⚠️ PK is `name` — **no `id` column**. Never sort with `order=id.asc`.

### `job_types` (lookup)
| Column | Type | Notes |
|---|---|---|
| id | SERIAL PK | |
| name | TEXT | e.g. "Standard - Stoneset" |
| cost | DECIMAL(10,2) | Default cost |

### `packets`
| Column | Type | Notes |
|---|---|---|
| id | TEXT PK | Client-generated |
| date | TEXT | DD MMM YYYY |
| retailer_id | INTEGER FK | → retailers |
| customer_ref | TEXT | Full ref e.g. "001-12345" |
| surname | TEXT | Only customer identifier stored |
| status_id | INTEGER FK | → billing_statuses |
| created / modified | TEXT | DD MMM YYYY |

### `packet_items`
| Column | Type | Notes |
|---|---|---|
| id | TEXT PK | Client-generated |
| packet_id | TEXT FK | → packets |
| item | TEXT | From items lookup |
| job_type_id | INTEGER FK | → job_types |
| cost | DECIMAL(10,2) | Editable, defaults from job_type |
| paula_pct / gabrielle_pct | INTEGER | 0–100, must sum to 100 |

### `billing_runs`
| Column | Type | Notes |
|---|---|---|
| id | TEXT PK | Client-generated |
| run_date | TEXT | DD MMM YYYY |
| user_name | TEXT | "paula" or "gabby" |
| retailer_ids | TEXT | Comma-separated retailer ids |
| packet_ids | TEXT | Comma-separated packet ids |
| status | TEXT | "completed" |
| created | TEXT | DD MMM YYYY |

### `appraisals` — legacy, not written to

---

## Key Concepts

**Customer reference:** Stored as `001-12345`. Retailer auto-fills the 3-digit prefix; user types 4–5 digit suffix. Tab from retailer jumps to suffix input.

**Cost split:** Calculated on the fly — never stored. `item.cost × (pct/100)` per item. `packetCosts(id)` returns `{total, paula, gabby}`.

**Financial year:** 1 April – 31 March (NZ).

**Users:** Gabby (default, sage `#5C7A6B`) · Paula (plum `#6E4B5E`). Toggle filters views and defaults split to 100% for selected user.

**Non-critical table loading:** `packet_items` and `billing_runs` are loaded outside the main `loadAll()` try/catch so a failure on either doesn't block the app from booting.

---

## Views / Screens

### Dashboard
- Greeting + "New Work Packet" button · 3 stat cards (New / Hold from Billing / Billed) · Billing pipeline placeholder · Recent packets (last 5) · Retailer breakdown sidebar

### Records
- Filter bar: Status pills · Retailer · User · Date range (presets + custom) · Search · Reset
- Cost column (Total / Paula / Gabby per User filter) · Batch status update · CSV export of filtered results

### New / Edit Work Packet
- Sticky header: Cancel + split Save button (Save = stays in edit mode; Save and Add New = fresh form)
- Packet Details: Date · Retailer* + Ref* · Surname*
- Items (up to 3 cards): Item · Job Type · Cost · Split slider (drag right = Gabby increases, 5% steps)
- Validation: client-side only, inline red errors, never re-renders on failure
- Edit mode: `renderAsync()` pre-fetches `packet_items` before rendering

### Run Billing
Multi-step flow — navigate via nav link:
1. **Selection:** Filter by status/date, all matching packet_items listed, pre-checked. "Start" button.
2. **Retailer loop (modal):** One screen per retailer. Items table + invoice summary (Job Types, user cost, subtotal, GST 15%, total). Back / Next / "Generate PDFs" on last retailer.
3. **Generate PDFs:** Preview + download per retailer (jsPDF, portrait A4). "Download All" if multiple. "Confirm + Mark as Billed" button.
4. **Confirm:** Packet counts per retailer, marks all selected packets as Billed, saves billing run to Supabase.

### Reports
- List of billing runs (date, user, retailers, packet count)
- Regenerate PDFs from any past run · Delete run

---

## Design System
**Fonts:** Playfair Display (headings/stats) · Outfit (UI) · DM Mono (refs/costs/dates)

| Colour | Hex | Usage |
|---|---|---|
| Deep | #2C2422 | Nav, primary buttons |
| Gold | #B8963E | CTAs, focus rings, Run Billing |
| Plum | #6E4B5E | Paula · Alexandra badge |
| Sage | #5C7A6B | Gabby · Billed |
| Ember | #B85C38 | Queenstown · errors |
| Sky | #4A7A9B | New status |

`-light` suffix variants used for backgrounds/badges.

---

## Code Conventions

**State:** `S` object — key props: `packets`, `allPacketItems`, `billingStatuses`, `retailers`, `jobTypes`, `items`, `editItems`, `recFilters`, `selectedPacketIds`, `billing`, `billingRuns`, `user`, `view`

**Render:** `render()` rebuilds entire DOM. `renderAsync()` pre-fetches edit data first. **Never call either from inside a form or validation handler.**

**Toast:** `toast()` calls `render()` — never use inside forms. Use `showToast()` instead (direct DOM inject, no re-render).

**Supabase helpers:** `sbAll`, `sbInsert`, `sbUpdate`, `sbDelete`, `sbUpsert`, `fetchPacketItems(id)`

**Key helpers:** `fmtD(d)` · `dateToISO(s)` · `parseStoredDate(s)` · `pad3(n)` · `fmtMoney(n)` · `packetCosts(id)` · `getBillingItems()` · `buildInvoiceSummary(items, retailerId)` · `statusName(id)` · `statusId(name)` · `statusBadgeStyle(name)` · `statusShowDash(id)`

**IDs:** Client-generated — `Date.now().toString(36) + random`

---

## Workflow
1. Build here in chat · Download `AppraisalTracker.html`
2. Claude Code: *"Replace index.html with downloaded file and push to GitHub"*
3. GitHub Pages deploys in ~2 minutes
4. DB changes: Supabase → SQL Editor

---

## Planned Features
- Billing pipeline workflow (status changes from dashboard)
- CSV format matching Solo accounting import
- Proper auth (replace user toggle)

---

## Learnings & Bug Prevention

This codebase has a consistent set of failure patterns. Read this before making any changes.

---

### Rule 1 — Variable declaration order matters (const/let hoisting)

`const` and `let` are NOT hoisted like `var`. A variable referenced before its declaration line throws `ReferenceError: Cannot access 'X' before initialization` — the app shows a blank screen with no visible UI error.

**This bit us multiple times:**
- `addItemBtn` declared after `rebuildItemsStack` which referenced it
- `saveBtn` declared after `doSave` which referenced it
- `selCount` declared after code that tried to use it

**Rules:**
- Always declare variables **before** any function or code that references them
- In render functions, declare all element variables at the top before any logic that uses them
- Before delivering a file, check: does any function reference a variable declared later in the same scope?

---

### Rule 2 — Never trigger render() from inside a form

`render()` rebuilds the entire DOM, wiping all draft form state (item cards, field values, everything). `toast()` also calls `render()` — twice (immediately + after 3 seconds via setTimeout).

**Symptoms:** Form resets on Save · Item cards disappear after validation error

**Rules:**
- Form validation: manipulate existing DOM elements directly only. No `render()`, no `toast()`.
- Use `showToast()` for any in-form feedback — it injects directly into DOM without re-rendering.
- After successful save: `renderAsync()` handles navigation, not `render()`.

---

### Rule 3 — Non-critical Supabase tables must load separately

If any `await` inside `loadAll()`'s main `try` block throws, the entire boot sequence aborts before `S.ready=true` — causing a permanent loading spinner with no error visible in the UI (only in the console).

**Tables that caused this:** `packet_items`, `billing_runs`

**Rule:** Load non-critical tables in their own `try/catch` blocks after the main block. A failure on these should warn to console but never block the app from loading.

```js
try { S.allPacketItems = await sbAll('packet_items', ...); }
catch(e) { console.warn('packet_items failed:', e); S.allPacketItems = []; }
```

---

### Rule 4 — Never assume a Supabase table has an `id` column

`items` table PK is `name`. Querying with `order=id.asc` throws Supabase error `42703: column does not exist`.

**Rule:** Every `sbAll` call specifies its own explicit `&order=` param. Never add a default order.

---

### Rule 5 — No non-ASCII characters in JavaScript

Non-ASCII characters (unicode arrows `→`, box-drawing `═`, em-dashes `—`, warning signs `⚠`, middle dots `·`) in JS strings or comments cause `SyntaxError: Invalid or unexpected token`, which crashes the entire script block. The app shows a loading spinner.

**This hit us with:** comment dividers using `═══`, button labels with `→`, section titles with `·`, literal newlines inside `\n` strings.

**Rules:**
- JS strings: ASCII only. Use `->` not `→`, `--` not `—`, `-` not `·`
- Comment dividers: use `// ===` not `// ═══`
- After building new code with Python, run a character scan to verify no non-ASCII in the script block
- `\n` in a Python-generated JS string must be `\\n` in the Python source to produce a literal backslash-n

---

### Rule 6 — Never use disabled buttons for primary actions

A disabled Start/Save button that stays disabled due to a state bug gives no feedback and no way to proceed. The user has no idea why nothing is happening.

**Rule:** Primary action buttons should always be clickable. Handle the "nothing selected" case inside the click handler with a `showToast()` message, not by disabling the button.

---

### Rule 7 — Blank screen = browser console first

Right-click → Inspect → Console. The error is always there, even when the UI shows nothing. Check this before asking for help — the error message usually identifies the exact line and variable.

---

### Pre-delivery checklist (run before every file handoff)

- [ ] No `const`/`let` variable referenced before its declaration in the same scope
- [ ] No `render()` or `toast()` called inside a form validation or error handler
- [ ] Non-critical Supabase tables loaded in separate `try/catch` blocks
- [ ] No non-ASCII characters in the `<script>` block
- [ ] No literal newlines inside JS string literals
- [ ] No duplicate variable declarations (`const X` appearing twice in same scope)
- [ ] Primary action buttons are not `disabled` — handle empty state in click handler
