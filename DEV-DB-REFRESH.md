# Dev Database Refresh

Replaces all app data in the **dev** Supabase project with the newest nightly **prod** backup.
Run it monthly, or any time dev's test data gets too messy to work against.

Dev logins are never affected.

---

## For Gabby — running it

### One-time setup (already done)

`psql` is installed via Homebrew at `/opt/homebrew/opt/libpq/bin/psql`.
If it ever goes missing, reinstall with:

```bash
brew install libpq
```

### Every time

**1. Get your dev database password.**
Supabase dashboard → **dev** project → **Project Settings → Database**.
If you don't know it, click **Reset database password** — that's completely safe on dev, nothing else uses it. Copy the new one verbatim; don't retype it.

**2. Open Terminal.** Cmd+Space → type `terminal` → Enter.

**3. Paste this line and press Enter:**

```bash
cd "/Users/gabriellelovering/Documents/Claude Projects/appraisal-tracker" && ./scripts/refresh-dev-from-prod.sh
```

**4. Follow the three prompts:**

| Prompt | What to do |
|---|---|
| `Password:` | Paste your dev password, press Enter. **The screen shows nothing while you paste** — no dots, no stars. That's normal, not a hang. |
| `Type REFRESH DEV to continue:` | Type `REFRESH DEV` exactly (capitals, one space), press Enter. Anything else safely aborts. |
| *(nothing — it runs)* | Wait. Takes a few seconds. |

**5. Check the result.** It ends with a table of row counts and `Done. Dev now matches backup_YYYY-MM-DD...`.
Then sign in to the dev app and glance at Records.

That's the whole process. If anything looks wrong, see Troubleshooting below — and note that **a failed run changes nothing at all**, so there's never a mess to clean up.

---

## Troubleshooting

**`psql: command not found` or `psql not found at /opt/homebrew/...`**
Run `brew install libpq`.

**`FATAL: (ENOTFOUND) tenant/user postgres.xwripwrfqdddfomzfjaq not found`**
Reads like a username problem, but it's almost always the **wrong region host**. Dev is in `ap-southeast-1`; prod is in `ap-southeast-2`. Check `DEV_HOST` in `scripts/refresh-dev-from-prod.sh` against the URI in Supabase's **Connect** modal (Session pooler). Can also mean the dev project is **paused** — the dashboard shows a "Restore" banner if so.

**`password authentication failed`**
Reset the password in the dashboard and use the new one. Never hand-edit or re-encode a password copied out of a Supabase URI — the URI shows it already percent-encoded, and re-encoding it double-escapes special characters into a failure that looks identical to a wrong password.

**`ABORT: dev's schema is behind prod's...`**
Prod has a column or table dev lacks. Apply that schema change to dev (SQL Editor is fine — it's a small statement), then re-run. Nothing was written.

**`ABORT: prod has table(s) this script doesn't know how to load`**
A new table was added to prod. Ask Claude to add it to `ORDER` in `scripts/build_refresh_sql.py`. Nothing was written.

**It seems to hang after the password**
Give it 10–15 seconds. It's connecting to Supabase in Singapore.

---

## For Claude — what you need to know

### The scripts

| File | Role |
|---|---|
| `scripts/refresh-dev-from-prod.sh` | Runner. Fetches the newest backup, prompts, confirms, invokes psql. |
| `scripts/build_refresh_sql.py` | Turns a prod `pg_dump` into a single-transaction refresh script. Also does the schema-drift check. |

### Rules — do not break these

1. **Never use the Supabase dashboard SQL Editor for the refresh.** It silently truncates a paste at **~9,500 characters** with no warning; the refresh SQL is ~70KB. The symptom is a baffling `ERROR: 42601: syntax error at end of input` with an empty `LINE 0:`. There is no file-import in the dashboard, and each execution is its own transaction, so a `BEGIN` cannot span two snippets — chunking would sacrifice atomicity. Use psql.
2. **Never guess the pooler hostname.** Dev is `aws-1-ap-southeast-1`; prod's backup URI in `PROJECT.md` is `aws-0-ap-southeast-2`. They are different projects in different regions. Get the real URI from the Connect modal (Session pooler) before writing any command.
3. **Never put the password in the command.** Use the `-W` prompt form, or `read -s` as the script does. A password embedded in a command line ends up in shell history — and, if Claude writes that command, in the conversation. This has already happened once and required a rotation.
4. **`auth.users` and `public.profiles` are never touched.** Dev keeps its own logins. `public.users` (the Gabby/Paula business rows) is **upserted, not truncated**, because `profiles.appraiser_id` references it — truncating it would need `CASCADE`, which would take `profiles` with it.
5. **Everything runs in one transaction.** Don't split the generated SQL. `-v ON_ERROR_STOP=1` plus `BEGIN`/`COMMIT` is what guarantees dev is never half-refreshed.
6. **Avoid `DO $$ ... $$` blocks** in anything that might get pasted into the SQL Editor. Editors that split statements on `;` cut the block in half and produce the same `syntax error at end of input`. Plain-SQL guards using `CASE ... END::int` work everywhere.

### If prod gains a new table

`build_refresh_sql.py` aborts rather than silently skipping it. Add it to `ORDER` **in foreign-key order, parents first**, then re-run. The current order is:

```
billing_statuses, retailers, job_types, items, sub_customers,
retailer_job_type_costs, shipping_runs, packets, packet_items,
nj_statements, nj_payments, nj_credit_notes, tax_invoices,
nj_statement_lines, billing_runs, id_reports
```

`users` is handled separately (upsert) and `profiles` is deliberately skipped.

### Verifying a run

The script ends with a row-count table. Compare against the source backup:

```bash
awk '/^COPY public\./{t=$2; n=0; b=1; next} b&&/^\\\.$/{print t": "n; b=0; next} b{n++}' prod.sql
```

`profiles` will differ — that's dev's own rows, correctly untouched.

### Known limitation

`id_reports` rows copy across, but `photo_path` points at prod's storage bucket, so those images won't load in dev. Copying storage objects is not part of this process.
