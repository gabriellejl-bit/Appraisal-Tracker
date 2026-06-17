# Design System Sync Log

Tracks changes made in this project's design system and whether they should be upstreamed to the base design system.

**Status tags:**
- `[BASE]` — generic enough to belong in the base; queue for the next sync session
- `[PROJECT]` — intentional project deviation; never upstream
- `[DONE]` — already applied to the base design system

---

## Process

1. Every change to `tokens/tokens.css` or `components/html/components.css` gets logged here with a status tag and a reason.
2. When there are 3+ `[BASE]` items, run a sync session (Claude Code can apply them directly to `design-system/`).
3. `[PROJECT]` items stay here permanently — they are the record of *why* this project diverges from the base.
4. The base design system must remain close to shadcn/Tailwind defaults. Do not upstream anything that is brand-specific, accessibility-override, or project-layout-specific.

---

## Pending — queue for base sync

| Item | File | Status | Reason |
|---|---|---|---|
| Input / Select error state (`.input.error`, `.select.error`) | `components/html/components.css` | `[BASE]` | Generic form validation pattern; missing from base |
| `--color-border-subtle` semantic token (currently using `--color-stone-200` directly) | `tokens/tokens.css` | `[BASE]` | Needed for section dividers; `--color-border` is too heavy, no lighter variant exists |

---

## Completed log

### Tokens

| Item | File | Status | Reason |
|---|---|---|---|
| OKLCH colour palette (gold, stone, zinc, etc.) | `tokens/tokens.css` + `tokens-html.css` | `[DONE]` | Values corrected from exact Figma hex — prior session generated from Tailwind defaults (wrong chroma/hue). Always convert from Figma variables, never interpolate. |
| `--color-primary` → `gold-600` | `tokens/tokens.css` | `[PROJECT]` | Obra brand colour; base stays neutral (zinc) |
| `--color-border` → `stone-500` / `stone-700` dark | `tokens/tokens.css` | `[PROJECT]` | Brand neutral choice |
| `--color-btn-brand-*` tokens (4 tokens) | `tokens/tokens.css` | `[PROJECT]` | Appraisal-tracker button colour aliases |

### Components — HTML

| Item | File | Status | Reason |
|---|---|---|---|
| Switch / Toggle component (`.switch`, `.switch__*`) | `components/html/components.css` | `[BASE]` | Generic utility, not in base HTML docs yet — add to `design-system/components/html/components.css` and doc page |
| Button presets: `.btn-primary`, `.btn-secondary`, `.btn-large`, `.btn-destructive`, `.btn-link` | `components/html/components.css` | `[PROJECT]` | Standalone project presets; base keeps BEM `.btn--*` variants |
| Icon button presets: `.btn-icon-primary`, `.btn-icon-secondary`, `.btn-icon-ghost` | `components/html/components.css` | `[PROJECT]` | 40px round icon buttons; project sizing and brand colours |
| Input / Textarea / Select height `2.75rem` (44px) | `components/html/components.css` | `[PROJECT]` | Accessibility requirement for this app; base stays at `2.25rem` (36px, shadcn default) |
| Input / Textarea / Select `font-size: text-base` (16px) | `components/html/components.css` | `[PROJECT]` | Matches 44px height and prevents iOS auto-zoom; base stays at `text-sm` |
| Label: uppercase, bold, `text-sm`, `margin-bottom: space-3` | `components/html/components.css` | `[PROJECT]` | Project visual style; base label is sentence-case, medium weight |
| Input / Textarea / Select `border-radius: radius-xl` | `components/html/components.css` | `[PROJECT]` | Project rounding preference; base uses `radius-md` |
| Input / Textarea / Select border → `color-border` (was `color-input`) | `components/html/components.css` | `[PROJECT]` | Project uses stone border token; `color-input` is the shadcn convention in base |
| Input / Select padding `0 var(--space-4)` (16px sides, 0 top/bottom) | `style-new.css` | `[PROJECT]` | Height is fixed at 44px so no top/bottom padding needed; md (16px) side padding per Figma |

---

## Base design system location

`/Users/gabriellelovering/Documents/Claude Projects/design-system/`

React components: `components/react/`
HTML/CSS components: `components/html/components.css`
Tokens: `tokens/tokens.css`
