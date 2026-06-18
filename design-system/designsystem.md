# Design System — Structure Reference

> Rules for using the design system (cascade, token naming, what to edit where) live in `../CLAUDE.md` under "Design System & Styling". Read that first.

---

## File layout

```
design-system/
  tokens/
    tokens.css          ← @theme {} source (Tailwind v4 format)
    tokens-html.css     ← plain :root {} version loaded in HTML <head>
  components/
    html/
      components.css    ← base component classes (@layer components)
  docs/
    index.html          ← live component reference (open before writing new styles)
  spacing-reference.md  ← legacy --space-lg etc. → new --space-5 etc. conversion table
  SYNC.md              ← log of changes to upstream to the base design system
```

## Source of truth hierarchy

| File | Role | Edit? |
|---|---|---|
| `tokens/tokens-html.css` | Token values — colours, spacing, radii, type | Only to add/change token values; never rename/restructure |
| `components/html/components.css` | Base component classes in `@layer components` | No — add project overrides in `style-new.css` instead |
| `../styles.css` | Legacy project stylesheet — being retired | No — never add to this |
| `../style-new.css` | Migration target; unlayered rules here win cascade | Yes — all project-specific overrides go here |

## Syncing with the base design system

This folder is a copy of `../design-system/` (the sibling repo). See `SYNC.md` for what needs upstreaming.

```bash
diff ../design-system/tokens/tokens.css design-system/tokens/tokens.css
diff ../design-system/components/html/components.css design-system/components/html/components.css
```

Only merge structural changes (new component classes, new token names). Do not overwrite local value customisations (e.g. `--color-primary` is tuned to the brand gold).
