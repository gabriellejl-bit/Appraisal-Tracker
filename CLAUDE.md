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

**Reference:** See `project_styling_progress.md` in memory for complete styling details. Figma file key: `bDb5CJBIcdtEKdKIsGYhs4`.

**Spacing:** `--space-xs` (8px) → `--space-6xl` (80px)

**Corner radius:** `--rounded-md` (6px), `--rounded-lg` (8px), `--rounded-xl` (12px), `--rounded-2xl` (16px), `--rounded-3xl` (24px), `--rounded-full`

**Typography:** `.h1`–`.h4` (Montserrat headings), `.para-lg`, `.para`, `.para-sm`, `.para-mini` (DM Sans body), `.caption`, `.mono`

**Buttons:** `.btn-primary` (gold), `.btn-secondary` (outline), `.btn-link` (text only), `.btn-destructive`, `.btn-sm` (size modifier)

**Form fields:** Inputs/selects = white bg, `1px solid var(--border)`, `--rounded-xl`, `var(--space-sm)` padding. Item area inputs override to secondary bg. Customer ref composite: prefix = warm bg (`--bg-warm`) + 3-sided border (no right), suffix = 3-sided border (no left) — looks like one joined field.

**Colour tokens:** Prefer Figma scale names — `--secondary`, `--foreground`, `--secondary-foreground`, `--brand-neutral-300`, `--brand-neutral-600`, `--violet-800`, `--gold-400`. Avoid legacy names (`--plum`, `--sage`, etc.).

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
