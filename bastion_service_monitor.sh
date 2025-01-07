#!/bin/bash
# SSH Service Health Monitor

LOG_FILE="/var/log/bastion_ssh_monitor.log"

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or with sudo privileges."
    exit 1
fi

if ! systemctl is-active --quiet sshd; then
    echo "[$(date)] SSH service was down. Restarting..." >> $LOG_FILE
    systemctl restart sshd
    echo "[$(date)] SSH service restarted." >> $LOG_FILE
else
    echo "[$(date)] SSH service is running fine." >> $LOG_FILE
fi
