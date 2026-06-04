# Billing Tracker - Quick Context

> Full reference: PROJECT.md

## What It Is
Billing tracker for jewellery appraisals. Two users (Paula, Gabby) invoice retailers based on per-job cost split percentages. Exception: combined-billing retailers (NJ + future) — Gabby invoices the retailer for full cost + GST, Paula invoices Gabby for her share.

## Stack
Single HTML file, vanilla JS, Supabase (PostgreSQL via REST, no SDK), GitHub Pages. No auth yet (user toggle in topbar). Two environments: prod (`index.html`) and dev (`AppraisalTracker-dev.html`, local only) — differ only by Supabase URL/key and title. External stylesheet: `styles.css`.

**Always deliver AppraisalTracker-dev.html for testing. Only deliver index.html (prod) when committing.**

## Core DB Entities
- **packets** — work jobs. PK: `id TEXT`. Has `paula_billed`/`gabby_billed` booleans, `status_id` FK, `sub_customer` TEXT (nullable, required for NJ).
- **packet_items** — line items per packet. PK: `id TEXT`. `paula_pct`/`gabrielle_pct` (sum to 100). `item TEXT` FK (not id).
- **items** — lookup. **PK is `name` (no id column)**. Sort by `display_order`.
- **job_types** — lookup with `cost`. Sort by `display_order`.
- **users** — `slug` UNIQUE. GST/tax rates per user. Gabby: 15% GST, 33% tax. Paula: no GST, 17.5% tax.
- **billing_statuses** — New(1), Hold(2), Billed(3), Archived(4). Billed is auto-managed only.
- **retailers** — Alexandra(1), Queenstown(2), Nationwide Jewellers(3, discount_pct=8.5). `code` displays zero-padded. Has `discount_pct DECIMAL` (default 0) and `combined_billing BOOLEAN` (default false). NJ has combined_billing=true.
- **retailer_job_type_costs** — (retailer_id, job_type_id, cost). Currently empty.
- **billing_runs** — audit trail. `packet_ids`/`retailer_ids` stored as CSV strings.

## Dashboard
- Shows "Unbilled Packets for [User]" — all unbilled packets for selected user
- Filters exclude Billed status and Hold/Archived packets
- 3 dollar cards: Unbilled / Earned This Week / Earned This Month (all POST-TAX, POST-DISCOUNT)
- 4 status count cards: New / On Hold / Part Billed / Fully Billed
- Quick actions: Search Records, Run Billing
- By Retailer breakdown (this month only, excludes Archived)

## Nationwide Jewellers (NJ) — Combined Billing
- `combined_billing = true` — Gabby invoices the retailer for FULL job cost + GST. Paula invoices Gabby for her % share.
- Gabby's Run Billing selection shows ALL NJ items (even where gabrielle_pct=0)
- Paula's selection shows only items where paula_pct > 0
- Step 2 modal title: Gabby → "[Retailer] — All", Paula → "[Retailer] — Invoice Gabby"
- Modal subtitle for Paula: "Invoice to: Gabby Lovering"
- PDF header: Gabby → retailer name only (no user name). Paula → "Invoice to: Gabby Lovering"
- Has sub-customers: currently 'NJ1', 'NJ2' (stored in S.subCustomers)
- sub_customer field on packet is required when retailer = NJ
- Free-text customer ref (no padded prefix, no length limit)
- NJ invoice summary groups items by sub-customer with subtotals + discount line
- Future combined-billing retailers: set `combined_billing=true` in DB — no code change needed

## Customer Reference
- **Standard retailers** (Alexandra/Queenstown): accepts up to 7 digits, format "001-1234567"
- **NJ**: free-text, no length limit
- Validation: standard refs require 4-7 digits

## Invoice Groupings (Run Billing)
Job types map to three billing categories on invoices and PDFs:
- **Valuations** — all job types not listed below (default)
- **Stock** — "Stock Update" and "Stock - New"
- **Pearl Threading** — "Pearl Threading"

`INVOICE_GROUPS` constant + `invoiceGroup(jtName)` implement this. NJ sub-customer breakdown uses raw job type names (unchanged).

## Run Billing Flow
1. **Selection** — date filter (default: last month), status filter. Date pills: All / Last Week / This Month / Last Month / Custom. Auto-selects eligible items on load via `b.initialised` flag (reset on nav click and user toggle).
2. **Retailer loop** — per-retailer modal: invoice summary first (copy/paste into billing system), then items table below.
3. **Generate PDFs** — jsPDF A4, Courier monospace. Title: "PGJ Appraisals, Detailed Report". Alexandra/Queenstown display as "Jamies Alexandra"/"Jamies Queenstown". Separator widths: 90 chars (standard), 100 chars (NJ).
4. **Confirm** — sets per-user billed flags, auto-sets status to Billed when both done.

## Critical Business Rules
1. Cost split calculated on the fly via `packetCosts(id)` → `{total, paula, gabby}`. Applies retailer `discount_pct`.
2. **Dashboard dollar cards are POST-TAX POST-DISCOUNT.** Formula: `cost * (1-discount%) * userPct% * (1-taxRate%)`.
3. Per-user billing is independent. When both billed (or one has 0% on all items), `status_id` auto-sets to Billed. Never set Billed manually.
4. Hold freezes billing toggles but allows detail edits. Archived freezes toggles.
5. GST conditional per user (from `users` table). Paula sees subtotal+total only. Applied after discount.
6. Financial year: 1 April–31 March (NZ).

## Key Helpers
`getCurrentUser()`, `packetCosts(id)`, `packetBillingLabel(pkt)`, `userHasBilled(pkt)`, `userHasNoWork(pktId)`, `getDollarStats()`, `getBillingItems()`, `isRetailerCombined(retailerId)`, `invoiceGroup(jtName)`, `buildInvoiceSummary(items, retailerId)` → `{byJobType, bySubCustomer, subtotal, gst, total, discountPct, isNJRetailer, isCombined, isCombinedGabby, isCombinedPaula}`, `fmtD(d)`, `fmtMoney(n)`, `statusName(id)`, `statusId(name)`, `pad3(n)`, `sbAll/sbInsert/sbUpdate/sbDelete/sbUpsert`, `fetchPacketItems(id)`, `showToast()` (safe anywhere), `renderAsync()` (post-save). Icon set `I` object (SVG strings in HTML).

## Design System (June 2026 refresh)
- **Figma library**: "Ombra kit - Appraisals Billing System" — source of truth for all components/tokens.
- **Colours**: Gold `#CEA12B` (primary CTA), Gold-dark `#995728` (hover), Teal `#269C9C` (Gabby/New status), Magenta `#B0215F` (Paula active), Rose `#9D174D` (Hold status), Chocolate `#4F2E1D` (labels), Dark-grey `#828282` (body text), Mid-grey `#B9B8B8` (inactive).
- **Containers**: No borders. Sidenav, topbar, main: background `#F8F7F7`, radius 20px, floating on 8px-padded white canvas.
- **Topbar**: 90px height, 4-column grid. Search (cols 1–2), NEW PACKET button (col 3), user toggle (col 4: 50×50px letter buttons + right-aligned name/email). Topbar button sizing is a separate pass — do not align to standard button spec yet.
- **Stat cards**: 261px × 180px, no borders. Standard: white. Primary (4th): radial gradient, all text white. Labels Montserrat 15px 800, values Montserrat 36px 800, subtitles DM Sans 14px 200.
- **Buttons** (Ombra kit — Round roundness only): `.btn` base 36px, `padding:8px 16px`, 14px DM Sans Medium. `.btn-gold` = Primary Large 42px, `padding:10px 24px`, 16px, gold fill `#CEA12B`, text `#FCF9F6`, hover gold-dark. `.btn-secondary` = Outline — white fill, `#995728` border, `--deep` text, hover: gold-dark fill + `#FCF9F6` text. `.btn-destructive` = red `#DC263B`. `.btn-small` = small inline surface button (unchanged). `.btn-primary` = small gold inline button (unchanged). TODO: `.btn-ghost`, size modifiers (`.btn-sm`, `.btn-lg`, `.btn-mini`) — deferred.
- **Status lozenges** (`.status-lozenge`): separate from buttons, 14px DM Sans 500, `padding:8px 16px`, pill. Active states are solid-colour: New = teal `#269C9C`, Hold = rose `#9D174D`, Archived = warm-grey `#92877B` (all `#FCF9F6` text). Inactive = surface bg, muted border/text. Hover shows the target active colour. Disabled = `#C9BEB2` fill. Uses `data-lozenge` attribute for per-type hover targeting.
- **Fonts**: Montserrat (display), DM Sans (body), DM Mono (mono). Jost removed.

## Coding Conventions
- **State object `S`** holds all app state incl. `subCustomers` array. `render()` = full DOM rebuild.
- **IDs:** `Date.now().toString(36) + random`.
- **Supabase:** raw fetch, no SDK. RLS enabled with open policies.
- Call `getCurrentUser()` once per function (don't create `cu2`/`cu3` copies).

## Bug Prevention Rules
1. **Declaration order** — `const`/`let` not hoisted. Reference before declaration = blank screen.
2. **Never `render()`/`toast()` inside a form** — wipes draft state. Use `showToast()` + `renderAsync()`.
3. **Non-critical tables** (`users`, `packet_items`, `billing_runs`) each in own `try/catch` — don't block boot.
4. **`items` has no `id` column** — never `order=id.asc`. Use `display_order.asc`.
5. **No non-ASCII in JS** — causes SyntaxError/spinner.
6. **Never disable primary buttons** — use `showToast()` for empty state feedback.
7. **Blank screen = check browser console first.**
8. **Auto-select uses `b.initialised` flag**, not `Set.size===0`. Reset on user toggle and nav.
9. **Use `!= null` for 0-valid numeric defaults**, never `||`.
10. **`stopPropagation()`** on nested buttons/checkboxes in clickable rows.
11. **Verify icon exists in `I` object** before adding any `ic()` call.
12. **Never append `&select=*` to sbAll** — already adds `?select=*`. Doubling returns duplicate rows.
13. **Always test in dev first** — use AppraisalTracker-dev.html.
