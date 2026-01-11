#!/usr/bin/env bash

#==============================
# Author: Aniket K.
# date: 10-01-2026
# This script performs log rotation.
#==============================


LOG_DIR="/var/log"
ARCHIVE_DIR="/var/log/archive"
RETENTION=7
TIMESTAMP=$(date +%Y-%m-%d_%H-%M)

# check for root user.

if [ "$EUID" -ne 0 ]; then
  echo "run this script as root user"
  exit 1
fi

echo "starting log rotation at $(date)"

# create archive directory if missing.

mkdir -p "$ARCHIVE_DIR"

# rotate .log files.

for LOG_FILE in "$LOG_DIR"/*.log; do
  [ -f "$LOG_FILE" ] || continue

  BASENAME=$(basename "$LOG_FILE")

  mv "$LOG_FILE" "$ARCHIVE_DIR/${BASENAME}_${TIMESTAMP}"
  touch "$LOG_FILE"

  echo "Rotated log: $BASENAME"
done

# compress archived logs

echo "Compressing logs..."
find "$ARCHIVE_DIR" -type f -name "*.log" -exec gzip {} \;

# cleanup old archived logs

echo "deleting logs older than $RETENTION days..."
find "$ARCHIVE_DIR" -type f -name "*.gz" -mtime +$RETENTION -delete

echo "Log rotation completed successfully."
