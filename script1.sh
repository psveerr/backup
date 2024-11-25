#!/bin/bash
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | cut -d'%' -f1)
DISK_USAGE_LESS=$(($DISK_USAGE - 10))
if [ "$DISK_USAGE" -gt 90 ]; then
    echo "WARNING: Disk usage is above 80% ($DISK_USAGE_LESS%)"
    exit 1
else
    echo "Disk usage is normal: $DISK_USAGE_LESS%"
fi
