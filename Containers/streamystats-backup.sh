#!/bin/sh
set -eu
cd /docker/streamystats
umask 077
mkdir -p backups
stamp=$(date +%Y%m%d-%H%M%S)
tmp="backups/streamystats-$stamp.dump.tmp"
trap 'rm -f "$tmp"' EXIT
docker compose exec -T streamystats pg_dump -U postgres -d streamystats -Fc > "$tmp"
mv "$tmp" "backups/streamystats-$stamp.dump"
tar -czf "backups/config-$stamp.tar.gz" compose.yaml .env
printf 'Backup created: %s\n' "backups/streamystats-$stamp.dump"
