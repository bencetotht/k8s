#!/bin/bash

# Settings
THRESHOLD=60
CRIT_THRESHOLD=20
UPS_NAME="ups@localhost"
CRUICAL_VMS=(101 102 103)

# Slack notification
SLACK_URL="https://hooks.slack.com/services"

# Separate PVE instance
SSH_HOST=""
SSH_USER=""
SSH_KEY="~/.ssh/id_rsa"

#############################################
BATTERY_LEVEL=$(upsc $UPS_NAME battery.charge 2>&1 | grep -v '^Init SSL')

# Shut down cruical VMs if battery level is below threshold
if [ "$BATTERY_LEVEL" -lt "$THRESHOLD" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S'): Battery level is below $THRESHOLD%. Shutting down cruical VMs..."
    curl -X POST -H 'Content-type: application/json' --data '{"text": "Battery level is below '$THRESHOLD'%. Shutting down cruical VMs..."}' $SLACK_URL
    
    for vmid in "${CRUICAL_VMS[@]}"; do
        qm shutdown $vmid
    done
else
    echo "$(date '+%Y-%m-%d %H:%M:%S'): Battery level is $BATTERY_LEVEL%. No action required."
fi

# Shut down all VMs if battery level is below critical threshold
if [ "$BATTERY_LEVEL" -lt "$CRIT_THRESHOLD" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S'): Battery level is '$BATTERY_LEVEL'%. Complete system shutdown..."
    curl -X POST -H 'Content-type: application/json' --data '{"text": "Battery level is '$BATTERY_LEVEL'%. Complete system shutdown..."}' $SLACK_URL
    qm shutdownall
    ssh -i $SSH_KEY $SSH_USER@$SSH_HOST "qm shutdownall"
fi