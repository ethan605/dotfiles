#!/bin/sh
set -eu

source_db=/data/logs.db
backup_dir=/backups

mkdir -p "$backup_dir"

exec 9>"$backup_dir/.logs-backup.lock"
if ! flock -n 9; then
  printf '%s backup already running; skipped\n' "$(date -u +%FT%TZ)"
  exit 0
fi

find "$backup_dir" -type f -name '*.partial*' -delete

if [ ! -f "$source_db" ]; then
  printf 'Source database is missing: %s\n' "$source_db" >&2
  exit 1
fi

timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
backup="$backup_dir/logs-$timestamp.db"
partial="$backup.partial"

cleanup() {
  rm -f "$partial"
}
trap cleanup 0
trap 'cleanup; exit 1' HUP INT TERM

attempts=0
until sqlite3 -cmd ".timeout 30000" "$source_db" ".backup '$partial'"; do
  attempts=$((attempts + 1))
  rm -f "$partial"
  if [ "$attempts" -ge 3 ]; then
    printf 'backup failed after %s attempts\n' "$attempts" >&2
    exit 1
  fi
  printf 'backup attempt %s failed; retrying in 10s\n' "$attempts" >&2
  sleep 10
done

if [ ! -s "$partial" ]; then
  printf 'Backup is missing or empty: %s\n' "$partial" >&2
  exit 1
fi

quick_check="$(sqlite3 "$partial" 'PRAGMA quick_check;')"
if [ "$quick_check" != "ok" ]; then
  printf 'quick_check failed for %s: %s\n' "$partial" "$quick_check" >&2
  exit 1
fi

mv -f "$partial" "$backup"
trap - 0

find "$backup_dir" -type f -name 'logs-*.db' -mtime +30 -print -delete

printf '%s backup verified: %s\n' "$(date -u +%FT%TZ)" "$backup"
