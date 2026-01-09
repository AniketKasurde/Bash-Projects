#!/usr/bin/env bash

THRESHOLD_CPU=80
THRESHOLD_MEM=80
THRESHOLD_DISK=90
CHECK_IP="8.8.8.8"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
LOG_FILE="$HOME/infra_health_$TIMESTAMP.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "--- Health Check Report: $(date) ---"

# CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | cut -d. -f1)

if [ "$CPU_USAGE" -gt "$THRESHOLD_CPU" ]; then
  echo "[ALERT] High CPU Usage: $CPU_USAGE%"
else
  echo "[OK] CPU Usage: $CPU_USAGE%"
fi

# Memory usage
MEM_USAGE=$(free | grep Mem | awk '{print int($3/$2 * 100)}')

if [ "$MEM_USAGE" -gt "$THRESHOLD_MEM" ]; then
  echo "[ALERT] High Memory Usage: $MEM_USAGE%"
else
  echo "[OK] Memory Usage: $MEM_USAGE%"
fi

# Disk usage
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')


if [ "$DISK_USAGE" -gt "$THRESHOLD_DISK" ]; then
  echo "[ALERT] High Disk Usage: $DISK_USAGE%"
else
  echo "[OK] Disk Usage: $DISK_USAGE%"
fi

# Network check
if ping -c 1 "$CHECK_IP" &> /dev/null; then
  echo "[OK] Internet Connectivity: Up"
else
  echo "[ALERT] Internet Connectivity: Down"
fi

