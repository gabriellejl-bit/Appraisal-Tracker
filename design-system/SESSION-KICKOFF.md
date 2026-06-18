# Session Kickoff — Design System Migration

Paste this prompt to start a new migration session.

---

## Prompt

We are continuing the design system migration for the appraisal-tracker app (`AppraisalTracker-dev.html`). Read `CLAUDE.md` and `MIGRATION.md` before touching anything — they contain the full architecture, cascade rules, file discipline, and current migration status.

### Where we are

Page-level audits complete: Records (canonical pattern), Billing Step 1, Customer Report, Billing Runs Report.

Remaining pages: Dashboard, Billing Steps 2–4, Reports landing.

For each remaining page, the same audit process applies:
1. Header → `page-header` + `h1`
2. Filter bar → `fld` helper (top-level function), `filterRow`, `.select` dropdowns
3. Table → `.table`, `table-header` on each individual `th` (not the `tr`)
4. Empty state → `.empty-state` / `.empty-state-title` / `.empty-state-hint`
5. Sweep for legacy tokens (`var(--gold)`, `var(--deep)`, etc.) and hardcoded px/hex values
6. Records page is the canonical reference — match its structure

### Hard rules (reminders)

- Edit `AppraisalTracker-dev.html` only — never `index.html`
- Never add new CSS classes without flagging first
- Fix visual bugs in `style-new.css` only — never in `components.css` (it loses the cascade)
- No hardcoded values — tokens only
- Bump `?v=N` on stylesheet links whenever CSS files change
