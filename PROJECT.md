# Billing Tracker — Project Context

## Purpose
A billing tracker for jewellery appraisal work. Paula and Gabby perform appraisals for jewellery retailers and track their work for invoicing. Each job is identified by the retailer's POS reference number. **Retailer is the primary billing entity** — Paula and Gabby invoice each retailer separately based on their work split.

## URLs
- **Live app:** https://gabriellejl-bit.github.io/Appraisal-Tracker/
- **Repository:** https://github.com/gabriellejl-bit/Appraisal-Tracker

## Architecture
- **Frontend:** Single HTML file (`index.html`) — vanilla JS, no framework
- **Database:** Supabase (PostgreSQL) via REST API (no SDK, raw fetch)
- **Hosting:** GitHub Pages
- **Auth:** None yet — user toggle in nav bar (Paula/Gabby)

## Supabase Config
- **Project URL:** `https://ytmyfarsptkezxkgpcbo.supabase.co`
- **API Key:** `sb_publishable_2POAMJdA5U1FPSgxzDy1oA_EfCnF6I2`
- Row Level Security enabled with open policies (no auth yet)

---

## Database Schema

### `retailers` (lookup — maintained in Supabase)
| Column | Type | Notes |
|---|---|---|
| id | SERIAL PK | |
| name | TEXT | e.g. "Alexandra" |
| code | INTEGER | e.g. 1 displays as "001" |

Seed: Alexandra (1), Queenstown (2)

### `items` (lookup — maintained in Supabase)
| Column | Type | Notes |
|---|---|---|
| name | TEXT PK | e.g. "Ring", "Watch" |

⚠️ PK is `name`, not `id`. Never query with `order=id.asc`.

Seed: Ring, Necklace, Bracelet, Watch, Earrings, Brooch, Pendant

### `job_types` (lookup — maintained in Supabase)
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
| status | TEXT | new / pending / unbilled / billed |
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

### `appraisals` (legacy — no longer written to)

---

## Customer Reference Format
- Stored as full string: `001-12345` (retailer code padded to 3 digits + dash + 4–5 digit suffix)
- Retailer dropdown auto-fills the prefix; user types only the suffix
- Tab from retailer field jumps cursor to the suffix input
- `dateToISO()` converts stored DD MMM YYYY back to YYYY-MM-DD for the date picker

---

## Users
- **Gabby** (Gabrielle) — default, sage green `#5C7A6B`
- **Paula** — plum `#6E4B5E`

User toggle filters dashboard/records to that user's work and defaults new entry split to 100% for the selected user.

---

## Views / Screens

### Dashboard (Home)
- Greeting + today's date, "New Work Packet" button (top right)
- 4 stat cards: New / Pending / Unbilled / Billed
- Billing pipeline visualisation (placeholder — workflow coming)
- Recent packets table (last 5) with edit buttons
- Sidebar: Quick Actions + Retailer breakdown bar chart

### Records
- All packets table, single search box (searches date, ref, surname)
- CSV export

### New / Edit Work Packet (Form)
**Sticky header:** Title + Cancel + split Save button (always visible on scroll)
- **Save** → saves and stays in edit mode (to review or add more items)
- **Save and Add New** (dropdown) → saves and opens a fresh blank form

**Packet Details section** (header — shared across all items):
- Date picker, Retailer* + Customer Reference* side by side, Surname* full width
- Mandatory fields marked with `*`, inline red error on save attempt
- Validation runs client-side only — never re-renders on failure (items preserved)

**Items section** (up to 3 cards, add/remove dynamically):
- Item (dropdown), Job Type (dropdown, auto-fills cost), Cost (editable, $)
- Work split slider: ◀ Paula — Gabby ▶. Drag right = Gabby increases. 5% increments.
- Defaults to 100% for active user

On save: 1 row inserted into `packets` + N rows into `packet_items`.
On edit load: `fetchPacketItems()` pre-fetches items via `renderAsync()` before form renders. If a job_type_id no longer exists in the lookup, a warning shows on that card.

---

## Design System
**Fonts:** Playfair Display (headings/stats) · Outfit (UI/body) · DM Mono (refs/costs/dates)

**Key colours:**
| Name | Hex | Usage |
|---|---|---|
| Deep | #2C2422 | Nav bar, primary buttons |
| Gold | #B8963E | CTAs, focus rings, slider |
| Plum | #6E4B5E | Paula, Alexandra badge |
| Sage | #5C7A6B | Gabby, billed status |
| Ember | #B85C38 | Queenstown badge, errors |
| Sky | #4A7A9B | Pending status |

Light variants (`-light` suffix) used for backgrounds/badges throughout.

---

## Code Conventions
- DOM built with `h(tag, attrs, ...children)` helper
- SVG icons in `I` object, rendered via `htmlContent` attr
- Global state in `S` object including `S.editItems` (pre-fetched packet items for edit)
- `render()` — synchronous, rebuilds entire DOM. **Never call from inside a form.**
- `renderAsync()` — async wrapper; fetches `S.editItems` before calling `render()`. Use for edit navigation.
- `toast()` — calls `render()`. **Never use inside a form.**
- `showToast()` — injects toast directly into DOM, no render. Safe inside forms.
- `fetchPacketItems(packetId)` — fetches packet_items from Supabase for edit mode
- `dateToISO(s)` — converts DD MMM YYYY → YYYY-MM-DD for date input
- `fmtD(d)` — formats Date object → DD MMM YYYY for storage
- `pad3(n)` — pads retailer code to 3 digits
- Supabase helpers: `sbAll`, `sbInsert`, `sbUpdate`, `sbDelete`, `sbUpsert`
- IDs generated client-side: `Date.now().toString(36) + random`
- Dates stored as DD MMM YYYY text (not ISO)

---

## Workflow
1. Make changes in this Claude chat or Claude Code
2. Download updated `AppraisalTracker.html`
3. Tell Claude Code: *"Replace index.html with the downloaded file and push to GitHub"*
4. GitHub Pages auto-deploys in ~2 minutes
5. Database changes: Supabase dashboard → SQL Editor

---

## Planned Features
- Billing status workflow (move packets through pipeline)
- CSV format matching Solo accounting app invoice import
- Proper auth / login (replace user toggle)
- Reporting by retailer for invoice generation

---

## Learnings & Bug Prevention

### 1. Never trigger render() from inside a form
**Covers:** Using `toast()` in validation, calling `render()` on error, const hoisting causing crashes.

**The core rule:** Anything that calls `render()` rebuilds the entire DOM — wiping the form and all draft items. This includes `toast()` (which calls `render()` immediately and again after 3 seconds).

**Symptoms:**
- Form resets after hitting Save (toast was called on validation failure)
- Blank screen with no error visible (a `const` variable was referenced before declaration, crashing inside a render function)

**Rules:**
- In form validation/error handling: manipulate existing DOM elements directly. Never call `render()` or `toast()`.
- Use `showToast()` for any feedback inside a form — it injects a toast element without re-rendering.
- Declare all UI element variables (`const el = h(...)`) **before** any function that references them — `const` is not hoisted like `var`.
- After a successful save, use `renderAsync()` not `render()` for edit navigation.

---

### 2. Never assume all Supabase tables have an `id` column
**Symptom:** App fails to load with error `42703: column does not exist`.

**Cause:** The `sbAll` helper was appending `&order=id.asc` to every query. The `items` table PK is `name`.

**Rule:** Each `sbAll` call specifies its own `&order=` param. The `items` table has no `id` — never sort it by id.

---

### 3. Blank screen = check browser console
**Rule:** Right-click → Inspect → Console. The error is always there even when the UI shows nothing.
