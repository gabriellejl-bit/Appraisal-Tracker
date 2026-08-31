#!/usr/bin/env bash
#
# Refresh the DEV Supabase database from the latest nightly PROD backup.
#
#   ./scripts/refresh-dev-from-prod.sh
#
# Pulls the newest backups/*.sql from origin/main, checks dev's schema can
# take it, then loads it in a single transaction. Dev's auth users and
# profiles are never touched, so dev logins keep working.
#
# Requires psql:  brew install libpq
#
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PSQL="/opt/homebrew/opt/libpq/bin/psql"

# The dev project is hardcoded on purpose: there is no way to point this
# script at prod without editing it.
DEV_REF="xwripwrfqdddfomzfjaq"
DEV_HOST="aws-1-ap-southeast-1.pooler.supabase.com"
URI="postgresql://postgres.${DEV_REF}@${DEV_HOST}:5432/postgres"

if [ ! -x "$PSQL" ]; then
  echo "psql not found at $PSQL"
  echo "Install it with:  brew install libpq"
  exit 1
fi

WORK="$(mktemp -d)"
# Generated SQL is disposable - regenerated from the backup on every run.
trap 'rm -rf "$WORK"' EXIT

echo "==> Fetching the latest prod backup"
git -C "$REPO" fetch --quiet origin main
LATEST="$(git -C "$REPO" ls-tree --name-only origin/main backups/ | sort | tail -1)"
if [ -z "$LATEST" ]; then
  echo "No backups found on origin/main. Has the nightly backup workflow run?"
  exit 1
fi
git -C "$REPO" show "origin/main:$LATEST" > "$WORK/prod.sql"
echo "    $LATEST"

echo
echo "Dev database password (from Supabase > Project Settings > Database)."
echo "Nothing appears as you type or paste - that is normal."
read -r -s -p "Password: " PGPASSWORD
echo
export PGPASSWORD

echo
echo "==> Checking dev's schema can accept prod's data"
"$PSQL" "$URI" -At -F $'\t' -q -c \
  "select table_name, string_agg(column_name, ',' order by ordinal_position)
     from information_schema.columns
    where table_schema = 'public'
    group by table_name" > "$WORK/dev-schema.tsv"

echo "==> Building the refresh script"
python3 "$REPO/scripts/build_refresh_sql.py" \
  "$WORK/prod.sql" "$WORK/dev-schema.tsv" "$WORK/refresh.sql"

cat <<EOF

This will REPLACE all app data in the DEV database.

  project : $DEV_REF
  host    : $DEV_HOST
  source  : $LATEST

Dev's auth users and profiles are NOT touched - your dev login is unaffected.

EOF
read -r -p "Type  REFRESH DEV  to continue: " CONFIRM
if [ "$CONFIRM" != "REFRESH DEV" ]; then
  echo "Aborted. Nothing was changed."
  exit 1
fi

echo
echo "==> Loading"
"$PSQL" "$URI" -v ON_ERROR_STOP=1 -q -f "$WORK/refresh.sql"

echo
echo "Done. Dev now matches $LATEST."
