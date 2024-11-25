pipeline {
    agent any

    environment {
        ALERT_EMAIL = "12veer34raj@gmail.com"      
        PROCESS_NAME = "apache2"              
        RESTART_COMMAND = "sudo systemctl restart apache2" 
        DISK_THRESHOLD = 10                   
    }
    triggers{
        cron('H * * * *')
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Execute Shell Script') {
            steps {
                sh '''
                # Make sure the script is executable and run it
                chmod +x ./script1.sh
                ./script1.sh
                '''
            }
        }

        stage('Monitor Disk Utilization') {
            steps {
                sh '''
                #!/bin/bash

                df -h | awk 'NR>1 {print $5 " " $6}' | while read output; do
                    usage=$(echo $output | awk '{print $1}' | sed 's/%//')
                    mount_point=$(echo $output | awk '{print $2}')
                    if [ "$usage" -gt "$DISK_THRESHOLD" ]; then
                        echo "Disk usage at $mount_point is $usage%!" | mail -s "Disk Usage Alert for $mount_point" $ALERT_EMAIL
                    fi
                done
                '''
            }
        }

        stage('Apache Process Management') {
            steps {
                sh '''
                #!/bin/bash

                if ! pgrep -x "$PROCESS_NAME" > /dev/null; then
                    echo "$PROCESS_NAME is not running. Attempting to restart..."
                    $RESTART_COMMAND
                    if [ $? -eq 0 ]; then
                        echo "$PROCESS_NAME restarted successfully."
                    else
                        echo "Failed to restart $PROCESS_NAME. Sending alert..."
                        echo "$PROCESS_NAME failed to restart!" | mail -s "Apache Restart Failed" $ALERT_EMAIL
                    fi
                else
                    echo "$PROCESS_NAME is running."
                fi
                '''
            }
        }
    }

    post {
        always {
            echo "Pipeline execution completed."
        }
    }
}
