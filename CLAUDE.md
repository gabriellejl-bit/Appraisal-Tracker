# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## CRITICAL: Dev/Prod File Discipline

**Always edit `AppraisalTracker-dev.html` — NEVER `index.html` during development.**

| File | Purpose | Supabase |
|---|---|---|
| `AppraisalTracker-dev.html` | Active dev file — edit this | Dev DB |
| `index.html` | Prod file — only updated when committing | Prod DB |

Rules:
- All code changes go into `AppraisalTracker-dev.html` first
- **Never generate the dev file from `index.html` using sed or copy** — the dev file is ahead of prod and has a different layout; overwriting it destroys work
- When the user approves changes for commit, copy dev to prod using `sed` to swap only `SB_URL`, `SB_KEY`, and `<title>` to prod values — never reverse this (never generate dev from prod)
- The preview server at port 8081 serves the whole directory — always navigate to `/AppraisalTracker-dev.html` to test

## Overview

Billing tracker for jewellery appraisals. Paula and Gabby invoice jewellery retailers independently based on per-job cost split percentages. Single HTML file + external stylesheet (`styles.css`), vanilla JS, Supabase (PostgreSQL via REST, no SDK), hosted on GitHub Pages.

Full project reference: `PROJECT.md` and `PROJECT-SHORT.md` — read these for DB schema, business rules, and design system details.

## Architecture

**Rendering:** Uses a custom `h(tag, attrs, ...children)` helper that creates DOM elements imperatively. Every state change calls `render()`, which wipes `#app` and rebuilds the entire DOM. No diffing.

**State:** A single global `S` object. Key fields: `S.view`, `S.packets`, `S.allPacketItems`, `S.items`, `S.retailers`, `S.jobTypes`, `S.billingStatuses`, `S.users`, `S.billing`, `S.recFilters`, `S.editId`, `S.user` (slug: `'gabby'` | `'paula'`), `S.subCustomers`.

**Backend:** Supabase via direct REST — `sbAll`, `sbInsert`, `sbUpdate`, `sbDelete`, `sbUpsert`, `fetchPacketItems(id)`.

**Layout:** Sidenav (220px) + topbar (90px) + main content area, all floating on a white canvas with 8px padding.

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

**Reference:** See `project_styling_progress.md` in memory for complete styling details, Figma reference (fileKey: `bDb5CJBIcdtEKdKIsGYhs4`).

**Spacing scale:** Global CSS variables `--space-xs` through `--space-6xl` (8px to 80px). Use for gaps, padding, margins.

**Corner radius:** `--rounded-md`, `--rounded-lg`, `--rounded-xl`, `--rounded-2xl`, `--rounded-3xl`, `--rounded-full`.

**Typography:** Utility classes `.h1`–`.h4` (headings), `.para`, `.para-lg`, `.para-sm`, `.para-mini` (body), `.caption`, `.mono`. All use DM Sans body font.

**Buttons:** `.btn-primary` (gold, 42px), `.btn-secondary` (outline, 42px), `.btn-link` (text only), `.btn-destructive`, `.btn-sm` (small inline 13px). Primary text is `#FCF9F6` (off-white).

**Form fields:** Inputs/selects = white bg, no border, `--rounded-xl` (12px), `var(--space-sm)` padding. Item area selects = secondary bg (#f3f0ed), border 1px, custom SVG chevron.

**Colour tokens:** Use Figma scale names: `--violet-800`, `--gold-400`, `--brand-neutral-300`, `--brand-neutral-600`, `--secondary`, `--foreground`, `--secondary-foreground`. Avoid legacy names (`--gold-dark`, plum, sage, etc.).

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
