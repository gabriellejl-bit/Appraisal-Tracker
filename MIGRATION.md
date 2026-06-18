# Style Migration Tracker

Tracks the migration from `styles.css` (legacy) to `style-new.css` (new, token-based).
When all rows are marked ✅ Done, `style-new.css` becomes `styles.css` and the legacy file is deleted.

## Load order (current)
1. `design-system/tokens/tokens-html.css` — plain CSS token variables
2. `design-system/components/html/components.css` — pre-built component classes
3. `styles.css` — legacy (retire when done)
4. `style-new.css` — migration target (rename to styles.css when done)

---

## Page-level audits

Tracks which pages have been fully audited for: correct page-header structure, filter bar pattern (`.select` dropdowns, `fld` helper, `filterRow`), table classes (`.table`, `table-header` on each `th`), empty state classes, and no legacy/hardcoded tokens.

| Page | Status | Notes |
|---|---|---|
| Records | ✅ Done | Canonical pattern — all other pages reference this |
| Billing Step 1 (Run Billing) | ✅ Done | Status + date range dropdowns; custom dates inline |
| Customer Report | ✅ Done | Date range first, retailer second; PDF button at bottom |
| Billing Runs Report | ✅ Done | `page-header` + `h1`; delete button removed (too risky without modal) |
| Dashboard | ⬜ Not started | `.stat-card`, `.panel`, `.dash-header` still in legacy styles.css |
| Billing Steps 2–4 | ⬜ Not started | |
| Reports landing | ⬜ Not started | Card grid; hardcoded px values present |

---

## CSS sections — `styles.css` → `style-new.css`

| Section | Lines | Status | Notes |
|---|---|---|---|
| `:root` token definitions | 1–23 | ⏳ Replace | Replaced in JS/HTML (global token sweep done). CSS `:root` block stays until styles.css is retired. |
| Typography scale (`.h1`–`.h4`) | 27–52 | ✅ Done | `.h1`–`.h4` added to `style-new.css` using tokens. `.para-*`/`.mono` not yet replaced. No uppercase on `.h4` globally — applied locally via inline style. |
| App shell (`.app-shell`) | 54–55 | ⬜ Not started | |
| Side nav | 57–74 | ⬜ Not started | |
| App body + topbar | 76–84 | ⬜ Not started | |
| User toggle | 86–95 | ⬜ Not started | |
| Main area | 97–99 | ⬜ Not started | |
| Dashboard | 101–133 | ⚠️ Partial | Legacy token vars replaced. Structural classes (`.stat-card`, `.panel`, `.dash-header` etc.) still in styles.css. |
| Content grid + panels | 135–143 | ⚠️ Partial | Legacy token vars replaced. `.content-grid`, `.panel`, `.panel-header`, `.panel-title`, `.sidebar` still in styles.css. |
| Table (Records results) | 145–164 | ✅ Done | `.table`, `.table-header`, `.table-row-selected`, text truncation, badge retirement, row selection state. |
| Sidebar + quick actions | 166–177 | ⬜ Not started | |
| Search bar | 179–184 | ⬜ Not started | |
| Form layout + sections | 186–201 | ✅ Done | `.form-wrap`, `.form-section`, `.form-section-title`, `.form-grid`, `.field-full`, `.label`, `.error-text` |
| Customer ref composite | 203–208 | ✅ Done | `.ref-wrap`, `.ref-prefix`, `.ref-suffix` |
| Item cards | 210–220 | ✅ Done | `.items-stack`, `.item-card`, `.item-card-header`, `.item-card-num`, `.item-card-remove`, `.item-card-grid`, `.item-card-bottom` |
| Cost field | 222–225 | ✅ Done | `.cost-wrap`, `.cost-symbol`, `.cost-input` |
| Split slider | 227–240 | ✅ Done | `.split-wrap` through `.split-pct` |
| Add item button | 242–244 | ✅ Done | `.add-item-btn` |
| Billing status card | 246–274 | ⚠️ Placeholder | Written in style-new.css but interaction pattern will be replaced; not final. |
| Form sticky header + actions | 276–280 | ✅ Done | `.form-sticky-header`, `.form-sticky-inner`, `.form-sticky-title`, `.form-sticky-actions`, `.form-bottom-actions` |
| Buttons | 282–302 | ⏳ Partial | `.btn-sm`, `.btn-link-destructive` added; split button not started. |
| Split button | 304–311 | ⬜ Not started | |
| Modal | 314–322 | ✅ Done | `.modal-overlay` through `.modal-footer-right` |
| Billing summary table | 324–332 | ⚠️ Partial | Customer Report migrated to `.table` + inline styles. Billing steps 2–4 may still reference `.summary-table`, `.total-row`, `.right`. |
| Step indicator | 334–341 | ⬜ Not started | |
| PDF preview | 343–350 | ⚠️ Partial | Legacy token vars replaced; hardcoded `#f8f8f8` → `var(--color-secondary)`, `borderRadius` → `var(--radius-md)`. |
| Toast | 352 | ⬜ Not started | |
| Loading screen + spinner | 355–358 | ⬜ Not started | |
| Keyframe animations | 360–364 | ⬜ Not started | |
| Media queries | 366–387 | ⬜ Not started | |
