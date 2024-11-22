#!/bin/bash

# Environment Variables
THRESHOLD=80
EMAIL="12veer34raj@gmail.com"
PROCESS_NAME="apache2"
RESTART_COMMAND="sudo systemctl restart apache2"

# Log File
LOG_FILE="/var/log/script1.log"

# Disk Utilization Monitoring
echo "Monitoring disk utilization..." | tee -a "$LOG_FILE"
df -h | awk 'NR>1 {print $5 " " $6}' | while read output; do
    usage=$(echo $output | awk '{print $1}' | sed 's/%//')
    mount_point=$(echo $output | awk '{print $2}')
    if [ "$usage" -gt "$THRESHOLD" ]; then
        echo "$(date): Disk usage at $mount_point is $usage%!" | tee -a "$LOG_FILE"
        echo "Disk usage alert: $mount_point is $usage%!" | mail -s "Disk Usage Alert for $mount_point" $EMAIL
    fi
done

# Process Management
echo "Checking if $PROCESS_NAME is running..." | tee -a "$LOG_FILE"
if ! pgrep -x "$PROCESS_NAME" > /dev/null; then
    echo "$(date): $PROCESS_NAME is not running. Restarting..." | tee -a "$LOG_FILE"
    $RESTART_COMMAND
    if [ $? -eq 0 ]; then
        echo "$(date): $PROCESS_NAME restarted successfully." | tee -a "$LOG_FILE"
    else
        echo "$(date): Failed to restart $PROCESS_NAME." | tee -a "$LOG_FILE"
    fi
else
    echo "$(date): $PROCESS_NAME is running." | tee -a "$LOG_FILE"
fi

echo "All tasks completed." | tee -a "$LOG_FILE"
