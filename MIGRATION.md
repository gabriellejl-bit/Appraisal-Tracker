# Style Migration Tracker

Tracks the migration from `styles.css` (legacy) to `style-new.css` (new, token-based).
When all rows are marked ✅ Done, `style-new.css` becomes `styles.css` and the legacy file is deleted.

## Load order (current)
1. `design-system/tokens/tokens-html.css` — plain CSS token variables
2. `design-system/components/html/components.css` — pre-built component classes
3. `styles.css` — legacy (retire when done)
4. `style-new.css` — migration target (rename to styles.css when done)

---

## Side-effects already active from loading `components.css`

These classes are used in the existing app AND defined in `components.css`. The new styles are
already applying. `styles.css` unlayered rules win on any conflicting property (cascade layers
are lower priority), but any property only defined in `components.css` takes effect immediately.

| Class | What changed | Status |
|---|---|---|
| `.input` | `height: 2.75rem` (44px) applied — styles.css had no explicit height | ✅ Accepted |
| `.badge` | components.css `.badge` base styles apply (gold bg, pill shape) — may conflict with `.badge-plum` / `.badge-ember` variants in styles.css | ⚠️ Needs check |
| `.btn-primary` `.btn-secondary` `.btn-destructive` `.btn-link` | components.css adds base layout; styles.css overrides visual properties (colour, size) since it's unlayered | ✅ Looks OK |

---

## Migration status by section

### `styles.css` sections → `style-new.css`

| Section | Lines | Status | Notes |
|---|---|---|---|
| `:root` token definitions | 1–23 | ⏳ Replace | Will be replaced entirely by `tokens-html.css` — delete when done |
| Typography scale (`.h1`–`.mono`) | 27–52 | ⬜ Not started | |
| App shell (`.app-shell`) | 54–55 | ⬜ Not started | |
| Side nav | 57–74 | ⬜ Not started | |
| App body + topbar | 76–84 | ⬜ Not started | |
| User toggle | 86–95 | ⬜ Not started | |
| Main area | 97–99 | ⬜ Not started | |
| Dashboard | 101–133 | ⬜ Not started | |
| Content grid + panels | 135–143 | ⬜ Not started | |
| Table | 145–164 | ⬜ Not started | |
| Sidebar + quick actions | 166–177 | ⬜ Not started | |
| Search bar | 179–184 | ⬜ Not started | |
| Form layout + sections | 186–201 | ✅ Done | `.form-wrap`, `.form-section`, `.form-section-title`, `.form-grid`, `.field-full`, `.label`, `.error-text` |
| Customer ref composite | 203–208 | ✅ Done | `.ref-wrap`, `.ref-prefix`, `.ref-suffix` |
| Item cards | 210–220 | ✅ Done | `.items-stack`, `.item-card`, `.item-card-header`, `.item-card-num`, `.item-card-remove`, `.item-card-grid`, `.item-card-bottom` |
| Cost field | 222–225 | ✅ Done | `.cost-wrap`, `.cost-symbol`, `.cost-input` |
| Split slider | 227–240 | ✅ Done | `.split-wrap` through `.split-pct` |
| Add item button | 242–244 | ✅ Done | `.add-item-btn` |
| Billing status card | 246–274 | ⚠️ Placeholder | Written in style-new.css but interaction pattern will be replaced; not final |
| Form sticky header + actions | 276–280 | ✅ Done | `.form-sticky-header`, `.form-sticky-inner`, `.form-sticky-title`, `.form-sticky-actions`, `.form-bottom-actions` |
| Buttons | 282–302 | ⏳ Partial | `.btn-sm`, `.btn-link-destructive` added; split button not started |
| Split button | 304–311 | ⬜ Not started | |
| Toast | 352 | ⬜ Not started | |
| Modal | 314–322 | ⬜ Not started | |
| Billing summary table | 324–332 | ⬜ Not started | |
| Step indicator | 334–341 | ⬜ Not started | |
| PDF preview | 343–350 | ⬜ Not started | |
| Loading screen + spinner | 355–358 | ⬜ Not started | |
| Keyframe animations | 360–364 | ⬜ Not started | |
| Media queries | 366–387 | ⬜ Not started | |
