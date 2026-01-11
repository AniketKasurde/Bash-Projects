#!/usr/bin/env bash

#==============================
# Author: Aniket K.
# date: 11-01-2026
# this script checks the service health & performs necesary actions.
#==============================

SERVICE_NAME="nginx"
LOG_FILE="/var/log/service_monitor.log"

# check for root user.

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# timestamp function

timestamp(){
  date "+%Y-%m-%d %H-%M"
}

# Logs messages to terminal AND to a file

log() {
    echo "$(timestamp) $1" | tee -a "$LOG_FILE"
}

# Check if the service is running

systemctl is-active --quiet "$SERVICE_NAME"

# Save exit code

STATUS=$?


# check service status & perform restart

if [ $STATUS -eq 0 ]; then
    log "[OK] $SERVICE_NAME is running"
    exit 0
else
    log "[ALERT] $SERVICE_NAME is down. Restarting..."
    systemctl restart "$SERVICE_NAME"

    if [ $? -eq 0 ]; then
        log "[RECOVERED] $SERVICE_NAME restarted successfully"
        exit 0
    else
        log "[FAILED] Could not restart $SERVICE_NAME"
        exit 2
    fi
fi














