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
15. **GST applies to everything unless explicitly stated otherwise** — all amounts (appraisals, job costs, etc.) are ex-GST and have GST added at invoice/display time via `getCurrentUser().gst_rate`. The only current exception is `shipping_runs.shipping_cost`, which is stored **GST-inclusive** (divide by 1.15 to get ex-GST). Do not invent new GST exclusions without explicit instruction.
16. **Duplicate declarations cause blank screen** — duplicate `const`/`function` in the same block scope (e.g. after a partial edit inside an `if(step===1){}` block) causes a SyntaxError where `S` is never defined and the app sticks on "Connecting…" with no console error. Always check for pre-existing declarations before adding new ones.
17. **Records page Total column shows raw cost — no discount** — `discount_pct` is never applied to the Records table display. Use raw `i.cost` (no `discountMult`), split by `paula_pct`/`gabrielle_pct` for per-user views. `packetCosts()` applies discount and is for billing calculations only — never use it for display in Records.
18. **Never use text as a PK or FK** — all database IDs must be integers or UUIDs. Text slugs are for display only. Text-based linking breaks silently on rename with no constraint error.
19. **Invoice line items use FULL cost — no discount** — `discount_pct` is an internal billing split between Gabby and Paula; it is never deducted on customer-facing invoices or packing slips. Use raw `i.cost` (no `discountMult`) in `printInvoice`, `getPacketRows`, and the shipping audit cost column.
20. **`S.user` (G/P toggle) is not login identity — never conflate them.** `S.user`/`getCurrentUser()` drive business logic (dashboard stats, GST, invoicing) and switch freely when the avatars are clicked. `S.session`/`S.profile` reflect who is actually authenticated and must never change on toggle clicks. This was a real bug: the header briefly showed the toggle's name instead of the logged-in account. See "Authentication" in `PROJECT.md`.

## Shipping & Invoicing

**`getShippingForBilling(retailerId)`** — finds shipping runs for a retailer within the current billing filter date range. Does NOT filter by selected packet IDs (Direct retailer packets may not appear in the user's selection even when shipped). Returns:
```js
{ total, totalExGST, bySubCustomer, bySubCustomerExGST, bySubCustomerRunCount, runs, runCount, dateLabel }
```

**`nextInvoiceNumber()`** — scans `S.shippingRuns` for existing `INV-XXXX` numbers, returns next padded string.

**`scName(id)`** — resolves a `sub_customers.id` value to a display name. Always use this for display; never use the denormalized `sub_customer_name` field for display logic.

**`openShipmentModal(filteredPackets)`** — two-step modal. Step 1: packet table + shipping cost input (default $6, stored GST-inclusive). Step 2: date + tracking + confirm. NJ sub-customers get "Print Invoice" instead of "Print Packing Slip".

**Step 1 modal summary format:** packet rows at full cost (no discount) → Shipping (net, input÷1.15) → Subtotal → GST (if user is GST-registered) → Total. The shipping input is gross (GST-inclusive); only shipping is divided by 1.15, not appraisals.

**Tax invoice (NJ only):** Title "TAX INVOICE", To = sub-customer + address, From = PGL Appraisals 34 Tarbert Street Alexandra 9320. Line items at full cost (no discount). Shipping ex-GST (stored ÷ 1.15). GST on full subtotal. `printInvoice()` — do NOT apply `discountMult` to row amounts. Logo (`assets/images/PGL-FULL-LOGO.png`) embedded as **base64 data URI** — the popup window has no base URL so relative paths don't resolve. Print headers/footers suppressed via `@page { margin: 0 }` in the popup's CSS.

**Billing Step 2 modal — NJ format:** One "Valuations - [sub-customer] - [date]" line + one "Shipping - [sub-customer] - [date] (N)" line per sub-customer. No job-type breakdown. Subtotal → discount → shipping total (ex-GST) → GST → Total.

**PDF detailed report — NJ:** Groups items by shipping run. Each run labelled `Invoice: INV-XXXX YYYY-MM-DD (tracking ...XXXX)`. Falls back to `Shipment:` for runs without an invoice number.

## Authentication

Internal staff tool — **sign-in only, no public sign-up**. Accounts are created directly in the Supabase dashboard (Authentication > Users), not through the app. Full detail in `PROJECT.md` under "Authentication"; quick reference for editing this code:

- `renderAuthPage()` covers sign-in and forgot-password (`S.authView`: `'login'` | `'forgotPassword'`). Do not add a sign-up form back in without being asked.
- `renderSetPasswordPage()` is a separate full-page override for invite-acceptance and password-reset landings (`S.authMode==='setPassword'`, reason `'invite'` or `'recovery'`) — it takes priority over both the login page and the app shell in `render()`. Sending invites themselves stays admin-only in the Supabase dashboard (needs the service-role key, which never belongs in this client-side app) — the app only handles the "set your password" landing.
- `render()` gates on `S.authMode` first, then `S.session` — if you add a new view, it's automatically protected; there's no per-route auth check to remember.
- Sign-in and forgot-password errors always show a generic message ("Invalid email or password" / "If an account exists...") — never surface the raw Supabase error there, it can leak whether an account exists or is unconfirmed. `renderSetPasswordPage()` is the one exception where a specific error is fine (the link is already tied to one account, so there's no enumeration risk).
- `onAuthStateChange` calls `render()` for `SIGNED_IN`/`SIGNED_OUT`/`PASSWORD_RECOVERY`. `TOKEN_REFRESHED`/`USER_UPDATED` update `S.session` silently — **do not add a `render()` call there**, it would wipe an in-progress Work Packet form draft on a background token refresh.
- `hdrs()` sends `S.session.access_token` when signed in, falling back to the anon `SB_KEY` only when signed out. Don't hardcode `SB_KEY` in new fetch calls — always go through `hdrs()`/`sbAll`/etc.
- `S.user` (G/P toggle) is **not** login identity — see rule 20 above. `S.profile` (from `public.profiles`, RLS-protected, one row per logged-in account) is the real identity; it's separate from `S.users` (the Gabby/Paula business rows the toggle switches between).
- `applyAppraiserDefault()` runs once after `loadAll()` on login/session-restore, defaulting `S.user` from `S.profile.appraiser_id`. It never runs on every render, so it won't fight a manual toggle click mid-session.

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
- [ ] No duplicate `const`/`function` declarations in the same block scope
- [ ] Invoice/packing slip line items use raw `i.cost` — no `discountMult`
- [ ] `S.user` (G/P toggle) not conflated with login identity (`S.session`/`S.profile`)
- [ ] No `render()` added inside `onAuthStateChange` for `TOKEN_REFRESHED`/`USER_UPDATED`
- [ ] Tested in browser against dev Supabase before reporting done
