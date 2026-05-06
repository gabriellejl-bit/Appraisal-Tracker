# Valuation Tracker — Project Context

## Purpose
A billing tracker for jewellery store valuations. Paula and Gabby perform valuations for jewellery retailers and need to track their work for invoicing purposes. Each valuation is identified by the retailer's POS reference number. Paula and Gabby invoice separately based on their percentage split of each job.

## Live URL
https://gabriellejl-bit.github.io/Appraisal-Tracker/

## Repository
https://github.com/gabriellejl-bit/Appraisal-Tracker

## Architecture
- **Frontend:** Single HTML file (`index.html`) — vanilla JS, no framework
- **Database:** Supabase (PostgreSQL) via REST API
- **Hosting:** GitHub Pages
- **Auth:** None yet — user toggle in nav bar (Paula/Gabby)

## Supabase Config
- **Project URL:** `https://ytmyfarsptkezxkgpcbo.supabase.co`
- **API Key:** `sb_publishable_2POAMJdA5U1FPSgxzDy1oA_EfCnF6I2`
- Row Level Security is enabled with open policies (no auth yet)

## Database Schema

### Table: `appraisals`
| Column | Type | Notes |
|---|---|---|
| id | TEXT (PK) | Generated client-side: `Date.now().toString(36) + random` |
| date | TEXT | British format: `DD MMM YYYY` (e.g. "07 May 2026") |
| customer_ref | TEXT | 5 or 6 digit number from retailer's POS system |
| surname | TEXT | Title-cased, the only customer identifier stored |
| first_name | TEXT | Deprecated — always empty string, kept for backward compat |
| retailer | TEXT | Currently: "Alexandra" or "Queenstown" |
| item | TEXT | From growing dropdown list (e.g. Ring, Necklace, Watch) |
| paula_pct | INTEGER | 0–100, Paula's share of the work |
| gabrielle_pct | INTEGER | 0–100, Gabby's share (paula_pct + gabrielle_pct = 100) |
| status | TEXT | Billing status: "new", "pending", "unbilled", "billed" — **NOT YET IN DB, needs ALTER TABLE** |
| created | TEXT | DD MMM YYYY format timestamp |
| modified | TEXT | DD MMM YYYY format timestamp |

**Indexes:** customer_ref, surname, retailer, item, date

### Table: `items`
| Column | Type | Notes |
|---|---|---|
| name | TEXT (PK) | Item type name |

**Seed data:** Ring, Necklace, Bracelet, Watch, Earrings, Brooch, Pendant

New items can be added via the form and are automatically saved to this table.

## Pending Database Change
The `status` column needs to be added:
```sql
ALTER TABLE appraisals ADD COLUMN status TEXT DEFAULT 'new';
```

## Users
- **Gabby** (Gabrielle) — default user, colour: sage green (`#5C7A6B`)
- **Paula** — colour: plum (`#6E4B5E`)

The user toggle filters the dashboard and records to show only valuations where that user's percentage is > 0. It also defaults the work split on new entries to 100% for the selected user.

## Views / Screens

### 1. Dashboard (Home)
- Greeting with user's name and today's date
- "New Valuation" button (gold, prominent)
- 4 stat cards: New / Pending / Unbilled / Billed counts (filtered to current user)
- Billing pipeline visualisation (placeholder — coming soon)
- Recent valuations table (last 5, filtered to current user) with split % bar
- Sidebar: Quick Actions (Search, Export CSV, Backup) + Retailer breakdown bar chart

### 2. Records
- Page title shows "[User]'s Records"
- Toolbar: Import, CSV, Backup buttons
- Single search box — searches across date, customer_ref, surname
- Full table: Date, Ref, Surname, Retailer, Item, Paula %, Gabby %, Edit button
- Filtered to current user (records where their % > 0)

### 3. New Valuation (Form)
- Fields: Date (date picker), Customer Reference (5–6 digits, mono font), Surname (title-cased), Retailer (dropdown), Item (dropdown + "New Item" option)
- Work Split: Paula/Gabby percentage inputs linked to total 100%, with colour bar
- Split defaults to 100% for whichever user is currently selected
- Validation: ref must be 5–6 digits, surname required, item required

### 4. Edit Valuation
- Same form as New, pre-populated with existing values
- Updates the `modified` timestamp on save

## Design System

### Aesthetic
Warm, professional jeweller's brand. Not corporate, not playful.

### Fonts
- **Display:** Playfair Display (headings, stats, greeting)
- **Body:** Outfit (UI text, labels, buttons)
- **Mono:** DM Mono (reference numbers, dates in tables)

### Colour Palette
| Name | Hex | Usage |
|---|---|---|
| Deep | #2C2422 | Nav bar, primary buttons, headings |
| Gold | #B8963E | Accents, CTAs, active states, logo border |
| Gold Light | #F7F0E0 | Icon backgrounds |
| Plum | #6E4B5E | Paula's colour, Alexandra retailer badge |
| Plum Light | #F3ECF0 | Badge backgrounds |
| Sage | #5C7A6B | Gabby's colour, connection status |
| Sage Light | #EBF2ED | Badge backgrounds |
| Ember | #B85C38 | Queenstown retailer badge, warnings |
| Ember Light | #FBF0EB | Badge backgrounds |
| Sky | #4A7A9B | Pending status |
| Sky Light | #EAF1F6 | Icon backgrounds |
| BG | #FAF8F5 | Page background |
| BG Warm | #F3EDE6 | Hover rows, split card bg |
| Surface | #FFFFFF | Cards, panels |
| Border | #E4DDD4 | Card borders |
| Text | #3A3230 | Primary text |
| Text Sec | #78706A | Secondary text |
| Text Muted | #B0A89F | Labels, placeholders |

### Components
- **Nav:** Dark deep bar, logo circle with gold border, centre nav links, right-side user toggle + connection status
- **Stat cards:** Top coloured 3px bar, icon in coloured circle, large Playfair number, uppercase label
- **Panels:** White card with header row (Playfair title + action link)
- **Badges:** Pill-shaped, plum for Alexandra, ember for Queenstown
- **Buttons:** Primary (deep bg), Gold (gold bg), Secondary (white + border)
- **Form inputs:** Subtle surface-alt background, gold focus ring
- **Toast:** Fixed top-right, deep bg, slide-in animation
- **Split bar:** Two-tone gradient (plum for Paula, sage for Gabby)

### Layout
- Max width: 1200px, centred
- Content grid: main area + 320px sidebar on dashboard
- Responsive: stacks at 900px and 640px breakpoints

## Data Operations
- **Records are append-only** — edits update in place with modified timestamp, nothing is deleted
- **CSV export** filtered to current user, named `valuations_[user]_[date].csv`
- **Backup** exports full database as JSON (all records, all items)
- **Import** is non-destructive — skips records with duplicate IDs
- IDs are generated client-side, not auto-increment

## Code Conventions
- Single HTML file, all JS inline in `<script>` tag
- DOM built with `h()` helper function: `h(tag, attrs, ...children)`
- SVG icons stored as string constants in `I` object
- State in global `S` object, `render()` function rebuilds entire DOM
- Supabase accessed via REST API with `fetch()`, no SDK
- Variable names are terse in render code (e.g. `S` for state, `sb` for supabase fetch)

## Workflow
1. Make changes here in Claude chat or in Claude Code
2. Copy updated file to `~/Desktop/appraisal-tracker/index.html`
3. In Claude Code or Terminal: `git add . && git commit -m "description" && git push`
4. GitHub Pages auto-deploys within ~2 minutes
5. Database changes: run SQL in Supabase dashboard SQL Editor

## Planned Features
- Billing status workflow (change status through pipeline)
- Cost calculations based on item type
- Default time splits per item type
- CSV format matching Solo accounting app invoice import
- Proper auth / login (replace user toggle)
- Reporting and filtering views
