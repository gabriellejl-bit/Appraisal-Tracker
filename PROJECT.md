# Billing Tracker — Project Context

## Purpose
A billing tracker for jewellery appraisal work. Paula and Gabby perform valuations for jewellery retailers and track their work for invoicing. Each job is identified by the retailer's POS reference number. **Retailer is the primary billing entity** — Paula and Gabby invoice each retailer separately based on their work split percentage per job.

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

All lookup tables are maintained directly in Supabase — no in-app editing.

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
| code | INTEGER | e.g. 1 → displays as "001" |

Seed: Alexandra (1), Queenstown (2)

### `items` (lookup)
| Column | Type | Notes |
|---|---|---|
| name | TEXT PK | e.g. "Ring", "Watch" |

⚠️ PK is `name` — no `id` column. Never sort with `order=id.asc`.

Seed: Ring, Necklace, Bracelet, Watch, Earrings, Brooch, Pendant

### `job_types` (lookup)
| Column | Type | Notes |
|---|---|---|
| id | SERIAL PK | |
| name | TEXT | e.g. "Standard - Stoneset" |
| cost | DECIMAL(10,2) | Default cost |

Seed: Standard - Stoneset ($60), Standard - Unset ($60), Watch/Charm Bracelet ($60)

### `packets` (one row per work packet)
| Column | Type | Notes |
|---|---|---|
| id | TEXT PK | Client-generated |
| date | TEXT | DD MMM YYYY |
| retailer_id | INTEGER FK | → retailers |
| customer_ref | TEXT | Full ref e.g. "001-12345" |
| surname | TEXT | Only customer identifier stored |
| status_id | INTEGER FK | → billing_statuses |
| created | TEXT | DD MMM YYYY |
| modified | TEXT | DD MMM YYYY |

### `packet_items` (one row per item within a packet)
| Column | Type | Notes |
|---|---|---|
| id | TEXT PK | Client-generated |
| packet_id | TEXT FK | → packets |
| item | TEXT | From items lookup |
| job_type_id | INTEGER FK | → job_types |
| cost | DECIMAL(10,2) | Editable, defaults from job_type |
| paula_pct | INTEGER | 0–100 |
| gabrielle_pct | INTEGER | 0–100 (paula + gabrielle = 100) |

### `appraisals` — legacy, not written to

---

## Key Concepts

**Customer reference:** Stored as full string `001-12345`. Retailer dropdown auto-fills the 3-digit prefix from `retailers.code`; user types only the 4–5 digit suffix. Tab from retailer jumps to the suffix input.

**Cost split:** Calculated on the fly — never stored. `item.cost × (pct / 100)` per item. `packetCosts(id)` returns `{total, paula, gabby}` summed across all items in a packet.

**Financial year:** 1 April – 31 March (NZ standard).

**Users:** Gabby (default, sage `#5C7A6B`) · Paula (plum `#6E4B5E`). Toggle filters views and defaults new entry split to 100% for selected user.

---

## Views / Screens

### Dashboard (Home)
- Greeting + date · "New Work Packet" button (gold, top right)
- 3 stat cards: New / Hold from Billing / Billed (Archived excluded)
- Billing pipeline placeholder (workflow coming with Run Billing)
- Recent packets table (last 5) · Sidebar: Quick Actions + Retailer breakdown

### Records
- Filter bar: Status pills · Retailer · User · Date range (Today / This Week / This Month / Last Month / This FY / Last FY / Custom)
- Single search box (ref, surname, date) across filtered results
- Cost column: Total / Paula / Gabby depending on User filter
- Batch status update: checkboxes + toolbar with status dropdown + Apply
- CSV export of filtered results (includes Total, Paula, Gabby cost columns)

### New / Edit Work Packet (Form)
- Sticky header: title + Cancel + split Save button (always visible on scroll)
  - **Save** → stays in edit mode after saving
  - **Save and Add New** (dropdown) → saves then opens fresh form
- **Packet Details:** Date · Retailer* + Ref* side by side · Surname* full width
- **Items** (up to 3 cards): Item · Job Type (sets cost) · Cost ($, editable) · Work split slider (◀ Paula — Gabby ▶, drag right = Gabby increases, 5% steps)
- Validation: client-side only, inline red errors, never re-renders on failure
- Edit mode: `renderAsync()` pre-fetches `packet_items` before rendering. Warning shown if job_type_id missing from lookup.

### Run Billing (placeholder — coming soon)
Weekly task: pull new records per user per retailer, generate invoice summary + PDF report. Nav item is greyed out. **Do not add to dashboard stats or reporting until built.**

---

## Design System
**Fonts:** Playfair Display (headings/stats) · Outfit (UI) · DM Mono (refs/costs/dates)

| Colour | Hex | Usage |
|---|---|---|
| Deep | #2C2422 | Nav, primary buttons |
| Gold | #B8963E | CTAs, focus rings, active states |
| Plum | #6E4B5E | Paula · Alexandra badge |
| Sage | #5C7A6B | Gabby · Billed status |
| Ember | #B85C38 | Queenstown badge · errors |
| Sky | #4A7A9B | New status |

`-light` suffix variants used for badge/icon backgrounds throughout.

---

## Code Conventions

**DOM & State**
- `h(tag, attrs, ...children)` — DOM builder helper
- `I` object — SVG icon strings, via `htmlContent` attr
- `S` — global state object. Key properties: `packets`, `allPacketItems`, `billingStatuses`, `retailers`, `jobTypes`, `items`, `editItems`, `recFilters`, `selectedPacketIds`, `user`, `view`

**Render functions**
- `render()` — synchronous, rebuilds entire DOM. **Never call from inside a form.**
- `renderAsync()` — async wrapper; pre-fetches `S.editItems` then calls `render()`. Use for edit navigation.

**Toast**
- `toast()` — calls `render()`. **Never use inside a form.**
- `showToast()` — injects toast into existing DOM, no render. **Always use inside forms.**

**Supabase**
- Helpers: `sbAll`, `sbInsert`, `sbUpdate`, `sbDelete`, `sbUpsert`
- `fetchPacketItems(packetId)` — loads items for edit mode

**Date & formatting**
- Stored as DD MMM YYYY text (not ISO)
- `fmtD(d)` — Date → DD MMM YYYY
- `dateToISO(s)` — DD MMM YYYY → YYYY-MM-DD (for date input value)
- `parseStoredDate(s)` — DD MMM YYYY → Date object (for filtering)
- `pad3(n)` — pads retailer code to "001" format
- `fmtMoney(n)` — formats as "$60.00"

**Status helpers** (always use name in UI, never raw id)
- `statusName(id)` · `statusId(name)` · `statusShowDash(id)` · `statusShowReport(id)` · `statusBadgeStyle(name)`

**Cost helpers**
- `packetCosts(packetId)` — returns `{total, paula, gabby}` calculated from `S.allPacketItems`

**IDs:** Client-generated — `Date.now().toString(36) + random`

---

## Workflow
1. Build/change in this chat
2. Download `AppraisalTracker.html`
3. Tell Claude Code: *"Replace index.html with the downloaded file and push to GitHub"*
4. GitHub Pages deploys in ~2 minutes
5. DB changes: Supabase → SQL Editor

---

## Planned Features
- Run Billing: invoice summary + PDF report per user per retailer (weekly)
- Billing pipeline workflow (status changes via dashboard)
- CSV format matching Solo accounting import
- Proper auth (replace user toggle)

---

## Learnings & Bug Prevention

### 1. Never trigger render() from inside a form
`render()` rebuilds the entire DOM — wiping all draft form state including item cards. `toast()` also calls `render()`.

**Rules:**
- Form validation: manipulate existing DOM elements only. No `render()`, no `toast()`.
- Use `showToast()` for in-form feedback.
- Declare UI variables (`const el = h(...)`) **before** any function that references them — `const` is not hoisted.
- After save, use `renderAsync()` not `render()` for edit navigation.

**Symptoms:** Form resets on Save (toast called during validation) · Blank screen (const referenced before declaration)

---

### 2. Never assume a Supabase table has an `id` column
`items` table PK is `name`. Sorting by `id` gives Supabase error `42703: column does not exist`.

**Rule:** Each `sbAll` call must specify its own `&order=` param explicitly.

---

### 3. Blank screen = open browser console immediately
Right-click → Inspect → Console. The error is always there.
