#!/bin/bash
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | cut -d'%' -f1)
if [ "$DISK_USAGE" -gt 10 ]; then
    echo "WARNING: Disk usage is above 10% ($DISK_USAGE%)"
    exit 1
else
    echo "Disk usage is normal: $DISK_USAGE%"
fi
