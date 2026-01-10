#!/usr/bin/env bash

LOG_DIR="/var/log"
LOG_PATTERN="*.log"
RETENTION=7


echo "--- LOG CLEANUP STARTED: $(date) ---"

#1. check for root privileges

if [ "$EUID" -ne 0 ]; then
  echo "[ERROR] this script must be run as root."
  exit 1
fi

#2. check if log directory exists.

if [ ! -d "$LOG_DIR" ]; then
  echo "[ERROR] log directory $LOG_DIR does not exist."
  exit 1
fi

#3. find old log files

OLD_LOGS=$(find "$LOG_DIR" -type f -name "$LOG_PATTERN" -mtime +$RETENTION)

#4. handle case when nologs found

if [ -z "$OLD_LOGS" ]; then
  echo "[INFO] no log files older than $RETENTION days found"
  exit 0
fi

#5. show logs that will be deleted.

echo "[INFO] deleting the following log file:"
echo "$OLD_LOGS"

#6. delete old logs
find "$LOG_DIR" -type f -name "$LOG_PATTERN" -mtime +$RETENTION -delete


echo "[SUCCESS] Log cleanup completed."
exit 0
