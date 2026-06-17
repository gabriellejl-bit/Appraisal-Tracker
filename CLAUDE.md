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
- **Never generate the dev file from `index.html`** if dev is ahead of prod — overwriting it destroys work. It is safe to regenerate dev from prod only when they are confirmed in sync (e.g. at the start of a session after a full merge, when the dev file has been deleted from the repo)
- To regenerate dev from prod: `sed` to swap only `SB_URL`, `SB_KEY`, and `<title>` — nothing else
- When the user approves changes for commit, copy dev to prod the same way
- The preview server at port 8081 serves the whole directory — always navigate to `/AppraisalTracker-dev.html` to test

## Overview

Billing tracker for jewellery appraisals. Paula and Gabby invoice jewellery retailers independently based on per-job cost split percentages. Single HTML file + external stylesheet (`styles.css`), vanilla JS, Supabase (PostgreSQL via REST, no SDK), hosted on GitHub Pages.

Full project reference: `PROJECT.md` — read for DB schema, business rules, and design system details.

## Architecture

**Rendering:** Custom `h(tag, attrs, ...children)` helper creates DOM elements imperatively. Every state change calls `render()`, which wipes `#app` and rebuilds the entire DOM. No diffing.

**State:** Single global `S` object — `S.view`, `S.packets`, `S.allPacketItems`, `S.items`, `S.retailers`, `S.jobTypes`, `S.billingStatuses`, `S.users`, `S.billing`, `S.recFilters`, `S.editId`, `S.user` (`'gabby'` | `'paula'`), `S.subCustomers`, `S.editItems`.

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
3. **Non-critical tables** (`users`, `packet_items`, `billing_runs`) must each be in their own `try/catch` — a failure must not block boot
4. **`items` has no `id` column** — sort with `&order=display_order.asc`, never `id.asc`
5. **No non-ASCII characters in JS** — causes SyntaxError/blank screen
6. **Never use `||` for 0-valid numeric defaults** — use `!= null` (e.g. `row.paula_pct != null ? row.paula_pct : 0`)
7. **`stopPropagation()`** on nested buttons/checkboxes inside clickable rows
8. **Verify icon exists in `I` object** before any `ic()` call
9. **Never append `&select=*` to `sbAll`** — it already includes `?select=*`; doubling it returns duplicate rows
10. **Auto-select uses `b.initialised` flag**, not `Set.size === 0`
11. **Declaration order** — `const`/`let` are not hoisted; never reference before declaration
12. **Dashboard dollar cards are POST-TAX, POST-DISCOUNT** — `getDollarStats()` must apply both `discount_pct` and `income_tax_rate`

## Design System & Styling

**In-progress migration** from `styles.css` (legacy) to `style-new.css` (token-based). See `MIGRATION.md` for status per section.

**Stylesheet load order:**
1. `design-system/tokens/tokens-html.css` — plain `:root {}` token variables (converted from `tokens.css` `@theme {}`)
2. `design-system/components/html/components.css` — base component classes (`.input`, `.label`, `.btn-*`, etc.) in `@layer components`
3. `styles.css` — legacy (retire when migration complete)
4. `style-new.css` — migration target; unlayered rules here override both legacy and layered components

**Cascade note:** `styles.css` is unlayered and loads after `@layer components`, so any property in `styles.css` beats `components.css`. Re-assert critical overrides unlayered in `style-new.css`.

**Figma source:** File key `Cc9WVPSYJoQDiSV4LV7Edk`. Raw colour variables in node `842-49172`.

**CRITICAL — OKLCH palette:** `tokens-html.css` and `tokens.css` contain OKLCH values converted from exact Figma hex values. Never regenerate these from Tailwind defaults or interpolate a scale — the brand palette (stone, gold, teal, etc.) differs significantly from Tailwind's equivalents. Always convert from Figma hex using the precise hex → OKLCH formula.

**Token naming:** Use new design system names — `--color-secondary`, `--color-foreground`, `--color-stone-300`, `--color-gold-400`, `--color-violet-700`, etc. Avoid all legacy names (`--plum`, `--sage`, `--bg-warm`, `--text-sec`, `--rounded-xl`, `--space-md`, etc.).

**Cache-busting:** `AppraisalTracker-dev.html` stylesheet links include `?v=N`. Increment N whenever CSS files change during active development to force browser cache refresh.

**Key component classes:** `.label` (text-sm, uppercase, bold), `.input` / `.select` (44px height, 16px side padding, radius-xl), `.btn-primary` (gold), `.btn-secondary` (outline), `.btn-sm` (size modifier), `.btn-link`, `.btn-destructive`. Form layout: `.form-section` (secondary bg card), `.form-grid` (2-col), `.item-card` (white bg, secondary inputs inside).

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
- [ ] Tested in browser against dev Supabase before reporting done
