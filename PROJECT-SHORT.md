# Billing Tracker - Quick Context

> Full reference: PROJECT.md (never modify this file without consulting it first)

## What It Is
Billing tracker for jewellery appraisals. Two users (Paula, Gabby) invoice retailers independently based on per-job cost split percentages.

## Stack
Single HTML file, vanilla JS, Supabase (PostgreSQL via REST, no SDK), GitHub Pages. No auth yet (user toggle in nav). Two environments: prod (`index.html` on GitHub) and dev (`AppraisalTracker-dev.html`, local only) — differ only by Supabase URL/key and title.

**Always deliver AppraisalTracker-dev.html for testing. Only deliver index.html (prod) when committing.**

## Core DB Entities
- **packets** — work jobs. PK: `id TEXT`. Has `paula_billed`/`gabby_billed` booleans, `status_id` FK, `sub_customer` TEXT (nullable, required for NJ).
- **packet_items** — line items per packet. PK: `id TEXT`. `paula_pct`/`gabrielle_pct` (sum to 100). `item TEXT` FK (not id).
- **items** — lookup. **PK is `name` (no id column)**. Sort by `display_order`.
- **job_types** — lookup with `cost`. Sort by `display_order`.
- **users** — `slug` UNIQUE. GST/tax rates per user. Gabby: 15% GST, 33% tax. Paula: no GST, 17.5% tax.
- **billing_statuses** — New(1), Hold(2), Billed(3), Archived(4). Billed is auto-managed only.
- **retailers** — Alexandra(1), Queenstown(2), Nationwide Jewellers(3, discount_pct=8.5). `code` displays zero-padded. Has `discount_pct DECIMAL` column (default 0).
- **retailer_job_type_costs** — (retailer_id, job_type_id, cost). Created for future per-retailer pricing, currently empty.
- **billing_runs** — audit trail. `packet_ids`/`retailer_ids` stored as CSV strings.

## Nationwide Jewellers (NJ)
- Flat 8.5% discount on all items (via retailers.discount_pct)
- Has sub-customers: currently placeholder 'NJ1', 'NJ2' (stored in S.subCustomers)
- sub_customer field on packet is required when retailer = NJ
- Free-text customer ref (no padded prefix format)
- Billing PDF/invoice groups items by sub-customer with subtotals + discount line

## Critical Business Rules
1. Cost split calculated on the fly via `packetCosts(id)` → `{total, paula, gabby}`. Applies retailer `discount_pct`.
2. **Dashboard dollar cards are POST-TAX POST-DISCOUNT.** Formula: `cost * (1-discount%) * userPct% * (1-taxRate%)`.
3. Per-user billing is independent. When both billed (or one has 0% on all items), `status_id` auto-sets to Billed. Never set Billed manually.
4. Hold freezes billing toggles but allows detail edits. Archived freezes toggles.
5. GST is conditional per user (from `users` table). Paula sees subtotal+total only. Applied after discount.
6. Financial year: 1 April–31 March (NZ).

## Key Helpers
`getCurrentUser()`, `packetCosts(id)`, `packetBillingLabel(pkt)`, `userHasBilled(pkt)`, `userHasNoWork(pktId)`, `getDollarStats()`, `getBillingItems()`, `buildInvoiceSummary(items, retailerId)` → `{byJobType, bySubCustomer, subtotal, gst, total, discountPct, isNJRetailer}`, `fmtD(d)`, `fmtMoney(n)`, `statusName(id)`, `statusId(name)`, `pad3(n)`, `sbAll/sbInsert/sbUpdate/sbDelete/sbUpsert`, `fetchPacketItems(id)`, `showToast()` (safe anywhere), `renderAsync()` (post-save).

## Coding Conventions
- **State object `S`** holds all app state incl. `subCustomers` array. `render()` = full DOM rebuild.
- **IDs:** `Date.now().toString(36) + random`.
- **Supabase:** raw fetch, no SDK. RLS enabled with open policies.
- Call `getCurrentUser()` once per function (don't create `cu2`/`cu3` copies).

## Bug Prevention Rules (memorise these)
1. **Declaration order** — `const`/`let` not hoisted. Reference before declaration = blank screen.
2. **Never `render()`/`toast()` inside a form** — wipes draft state. Use `showToast()` + `renderAsync()`.
3. **Non-critical tables** (`users`, `packet_items`, `billing_runs`) each in own `try/catch` — don't block boot.
4. **`items` has no `id` column** — never `order=id.asc`. Use `display_order.asc`.
5. **No non-ASCII in JS** — causes SyntaxError/spinner. Scan script block before delivering.
6. **Never disable primary buttons** — use `showToast()` for empty state feedback.
7. **Blank screen = check browser console first** (Inspect → Console).
8. **Auto-select uses `b.initialised` flag**, not `Set.size===0`.
9. **Use `!= null` for 0-valid numeric defaults**, never `||`.
10. **`stopPropagation()`** on nested buttons/checkboxes in clickable rows.
11. **Verify icon exists in `I` object** before adding any `ic()` call.
12. **Never append `&select=*` to sbAll** — sbAll already adds `?select=*`. Doubling it returns duplicate rows from Supabase.
13. **Always test in dev first** — downloaded file from GitHub Pages has prod credentials. Use AppraisalTracker-dev.html.

## Pre-Delivery Checklist
No early const/let refs · No render()/toast() in forms · Non-critical tables in separate try/catch · No non-ASCII in JS · No literal newlines in JS strings · No duplicate declarations · Primary buttons not disabled · Auto-select uses b.initialised · Numeric defaults use != null · Nested row elements have stopPropagation · All ic() refs exist in I object · No &select=* in sbAll queries · Delivering dev file for testing
