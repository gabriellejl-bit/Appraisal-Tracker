# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## CRITICAL: Branch Discipline

**Always work on `dev` — NEVER commit to `main` directly.**

- All development commits go to `dev`
- `main` is production-only — updated only when merging `dev` for a release
- A pre-commit hook enforces this: any commit attempt on `main` will be blocked with an error
- If you find yourself on `main`, stop and run `git checkout dev` before making any changes

## CRITICAL: Dev/Prod File Discipline

**Always edit `AppraisalTracker-dev.html` — NEVER `index.html` during development.**

| File | Purpose | Supabase |
|---|---|---|
| `AppraisalTracker-dev.html` | Active dev file — edit this | Dev DB |
| `index.html` | Prod file — only updated when committing | Prod DB |

Rules:
- All code changes go into `AppraisalTracker-dev.html` first
- **Never generate the dev file from `index.html`** if dev is ahead of prod — overwriting it destroys work. Safe to regenerate only when they are confirmed in sync (e.g. start of session after a full merge)
- To regenerate dev from prod: `sed` to swap only `SB_URL`, `SB_KEY`, and `<title>` — nothing else
- When the user approves changes for commit, copy dev to prod the same way
- The preview server at port 8081 serves the whole directory — always navigate to `/AppraisalTracker-dev.html` to test

## Overview

Billing tracker for jewellery appraisals. Paula and Gabby invoice jewellery retailers independently based on per-job cost split percentages. Single HTML file + external stylesheet (`styles.css`), vanilla JS, Supabase (PostgreSQL via REST, no SDK), hosted on GitHub Pages.

Full project reference: `PROJECT.md` — read for DB schema, business rules, and design system details.

## Architecture

**Rendering:** Custom `h(tag, attrs, ...children)` helper creates DOM elements imperatively. Every state change calls `render()`, which wipes `#app` and rebuilds the entire DOM. No diffing.

**State:** Single global `S` object. Key fields:
- `S.view`, `S.editId`, `S.user` (`'gabby'` | `'paula'`), `S.currentUser`
- `S.packets`, `S.allPacketItems`, `S.retailers`, `S.jobTypes`, `S.billingStatuses`, `S.users`
- `S.subCustomers` — full rows from `sub_customers` table (with address fields)
- `S.shippingRuns` — full rows from `shipping_runs` table
- `S.shippingFilters` `{retailerId, subCustomer}`, `S.shippingSelected` (Set of packet ids)
- `S.shippingReport`, `S.fulfilmentReport` — filter state `{dateRange, dateFrom, dateTo}`
- `S.billing`, `S.billingRuns`, `S.recFilters`, `S.editItems`

**Backend:** Supabase via direct REST — `sbAll`, `sbInsert`, `sbUpdate`, `sbDelete`, `sbUpsert`, `fetchPacketItems(id)`.

**Layout:** Sidenav (220px) + topbar (90px) + main content area, all floating on a white canvas with 8px padding.

## renderForm() Structure

`renderForm(packet)` is the Work Packet form (~550 lines). Sections and helpers inside it:

```
// -- PACKET HEADER STATE (hdr) --   mutable fields: dateISO, retailerId, customerRef, refSuffix, surname, subCustomer
// -- ITEM STATE --                   formItems[] — pre-loaded from S.editItems (edit) or blank (new)
// -- FIELD ERROR HELPERS --
  clearFieldError(input, errorEl)     removes .error class, hides message
  showFieldError(input, errorEl, msg) adds .error class, sets message, shows it
// -- PACKET DETAILS SECTION --       billing status, date, retailer, ref, sub-customer, surname
  syncCustomerRef()                   writes hdr.customerRef from current inputs (NJ = free text, others = prefix+suffix)
  rebuildCustomerRefInput()           swaps refWrap between free-text (NJ) and prefix+suffix (standard)
  rebuildSubCustomerSelect()          builds/rebuilds NJ sub-customer dropdown
// -- ITEMS SECTION --
  buildItemCard(item, index)          builds an item card DOM node
  buildSplitSlider(item)              builds Paula/Gabby split slider (called from buildItemCard)
  rebuildItemsStack()                 clears and re-renders all item cards
// -- SAVE LOGIC --
  validateForm()                      returns {valid, firstError} — shows errors inline, never calls render()/toast()
  doSave(saveAndNew)                  validates then calls savePacket/updatePacket
```

## Bug Prevention Rules (read before every edit)

1. **Edit the dev file** — `AppraisalTracker-dev.html`, not `index.html`
2. **Never `render()` or `toast()` inside a form** — wipes draft state. Use `showToast()` + `renderAsync()` instead
3. **Non-critical tables** (`users`, `packet_items`, `billing_runs`, `sub_customers`, `shipping_runs`) must each be in their own `try/catch` — a failure must not block boot
4. **`items` has no `id` column** — sort with `&order=display_order.asc`, never `id.asc`
5. **No non-ASCII characters in JS** — causes SyntaxError/blank screen
6. **Never use `||` for 0-valid numeric defaults** — use `!= null` (e.g. `row.paula_pct != null ? row.paula_pct : 0`)
7. **`stopPropagation()`** on nested buttons/checkboxes inside clickable rows
8. **Verify icon exists in `I` object** before any `ic()` call. `ic()` returns a DOM element — use `el.innerHTML = I.check` (not `ic('check')`) when setting cell content
9. **Never append `&select=*` to `sbAll`** — it already includes `?select=*`; doubling it returns duplicate rows
10. **Auto-select uses `b.initialised` flag**, not `Set.size === 0`
11. **Declaration order** — `const`/`let` are not hoisted; never reference before declaration
12. **Dashboard dollar cards are POST-TAX, POST-DISCOUNT** — `getDollarStats()` must apply both `discount_pct` and `income_tax_rate`
13. **`replace_all` edits corrupt declaration lines** — never use `replace_all` to rename a variable; the declaration `const foo=foo` will be produced. Rename the declaration and usages separately
14. **Map optimisations are function-local** — `itemsByPacketId`, `packetsByRunId` etc. are built inside render functions. Never reference them from separate top-level functions like `openShipmentModal`
15. **GST on shipping** — shipping costs in `shipping_runs` are stored **GST-inclusive**. Always divide by 1.15 to get ex-GST for display. `getShippingForBilling()` pre-computes `totalExGST` and `bySubCustomerExGST` — use those instead of dividing at call sites

## Shipping & Invoicing

**`getShippingForBilling(retailerId)`** — finds shipping runs for a retailer within the current billing filter date range. Does NOT filter by selected packet IDs (Direct retailer packets may not appear in the user's selection even when shipped). Returns:
```js
{ total, totalExGST, bySubCustomer, bySubCustomerExGST, bySubCustomerRunCount, runs, runCount, dateLabel }
```

**`nextInvoiceNumber()`** — scans `S.shippingRuns` for existing `INV-XXXX` numbers, returns next padded string.

**`openShipmentModal(filteredPackets)`** — two-step modal. Step 1: packet table + shipping cost. Step 2: date + tracking + confirm. NJ sub-customers get "Print Invoice" (tax invoice PDF) instead of "Print Packing Slip". Invoice number generated on first print, saved to `shipping_runs.invoice_number` on confirm.

**Tax invoice (NJ only):** Title "TAX INVOICE", To = sub-customer + address, From = PGL Appraisals 34 Tarbert Street Alexandra 9320. GST rate from `getCurrentUser().gst_rate`. Shipping displayed ex-GST (stored ÷ 1.15).

**Billing Step 2 modal — NJ format:** One "Valuations - [sub-customer] - [date]" line + one "Shipping - [sub-customer] - [date] (N)" line per sub-customer. No job-type breakdown. Subtotal → discount → shipping total (ex-GST) → GST → Total.

**PDF detailed report — NJ:** Groups items by shipping run. Each run labelled `Invoice: INV-XXXX YYYY-MM-DD (tracking ...XXXX)`. Falls back to `Shipment:` for runs without an invoice number.

## Design System & Styling

**In-progress migration** from `styles.css` (legacy) to `style-new.css` (token-based). See `MIGRATION.md` for status per section.

**Stylesheet load order:**
1. `design-system/tokens/tokens-html.css` — plain `:root {}` token variables
2. `design-system/components/html/components.css` — base component classes in `@layer components`
3. `styles.css` — legacy (retire when migration complete)
4. `style-new.css` — migration target; unlayered rules here override both legacy and layered components

**CRITICAL — `styles.css` is legacy. Never read it, never reference it, never diagnose from it.** Fix visual bugs by re-asserting the correct value in `style-new.css`.

**CSS Cascade Rule (CRITICAL):** `@layer components` has *lower* priority than unlayered rules. To fix a visual bug: re-assert the property in `style-new.css` (unlayered, loads last, wins).

**Figma source:** File key `Cc9WVPSYJoQDiSV4LV7Edk`. Raw colour variables in node `842-49172`.

**CRITICAL — OKLCH palette:** Never regenerate from Tailwind defaults — always convert from Figma hex using the precise hex → OKLCH formula.

**Token naming:** Use new design system names — `--color-secondary`, `--color-foreground`, `--color-stone-300`, `--color-gold-400`, `--color-violet-700`, etc. Avoid all legacy names (`--plum`, `--sage`, `--bg-warm`, `--text-sec`, etc.).

**Cache-busting:** Increment `?v=N` on stylesheet links whenever CSS files change during active development.

**Key component classes:** `.label`, `.input` / `.select` (44px height), `.btn-primary` (gold), `.btn-secondary`, `.btn-sm`, `.btn-link`, `.btn-destructive`, `.table`. Form layout: `.form-section`, `.form-grid` (2-col), `.item-card`.

## Pre-Delivery Checklist

- [ ] Edited `AppraisalTracker-dev.html` (not `index.html`)
- [ ] No `render()`/`toast()` inside form validation
- [ ] Non-critical tables in separate `try/catch`
- [ ] No non-ASCII in script block
- [ ] No literal newlines in JS strings
- [ ] No duplicate variable declarations in same scope
- [ ] Numeric defaults use `!= null` not `||`
- [ ] Nested row elements have `stopPropagation`
- [ ] All `ic()` references exist in `I` object
- [ ] No `&select=*` appended to `sbAll` queries
- [ ] Map optimisations not leaked into other function scopes
- [ ] Tested in browser against dev Supabase before reporting done
