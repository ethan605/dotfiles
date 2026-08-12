#!/bin/sh
set -eu

crond_pid=""
term_handler() {
  if [ -n "$crond_pid" ]; then
    kill -TERM "$crond_pid" 2>/dev/null || true
    wait "$crond_pid" 2>/dev/null || true
  fi
  exit 0
}
trap term_handler TERM INT

: "${TZ:=UTC}"
export TZ

case "$TZ" in
  /*|*..*)
    printf 'Invalid TZ: %s\n' "$TZ" >&2
    exit 2
    ;;
esac

tzfile="/usr/share/zoneinfo/$TZ"
if [ ! -f "$tzfile" ] || [ "$(dd if="$tzfile" bs=4 count=1 2>/dev/null)" != "TZif" ]; then
  printf 'Invalid TZ: %s\n' "$TZ" >&2
  exit 2
fi

cat > /etc/crontabs/root <<EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
TZ=$TZ
0 3 * * * /usr/local/bin/backup-logs-db >>/proc/1/fd/1 2>&1
EOF

chmod 0600 /etc/crontabs/root

exec 9>/backups/.logs-backup.lock
if flock -n 9; then
  find /backups -type f -name '*.partial' -delete
fi
exec 9>&-

/usr/sbin/crond -f -l 2 -L /proc/1/fd/1 &
crond_pid=$!
wait "$crond_pid"
