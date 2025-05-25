#!/bin/bash

set -euo pipefail

OUTFILE="$HOME/.env/LAPTOP_IP"
mkdir -p "$(dirname "$OUTFILE")"

if [ -e "$OUTFILE" ]; then
	IP=$(< "$OUTFILE")
	curl --max-time 0.5 -s http://"$IP":8123 -o /dev/null 2>/dev/null && exit 0
fi

LAPTOP=$(
  seq 1 254 | xargs -P 254 -I {} bash -c \
    'curl --max-time 0.5 -s http://192.168.1.{}:8123 -o /dev/null && echo "192.168.1.{}"' \
  | head -n 1
)

if [ -n "$LAPTOP" ]; then
  echo "$LAPTOP" > "$OUTFILE"
fi
