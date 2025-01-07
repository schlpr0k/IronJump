#!/bin/bash
# Password Rotation for Bastion Users

BASTION_GROUP="bastion"
LOG_FILE="/var/log/bastion_password_rotation.log"

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or with sudo privileges."
    exit 1
fi

echo "[$(date)] Starting password rotation..." >> $LOG_FILE

for user in $(getent group $BASTION_GROUP | awk -F: '{print $4}' | tr ',' ' '); do
    if [[ -f "/home/$user/.ssh/authorized_keys" ]]; then
        NEW_PASSWORD=$(openssl rand -base64 16)
        echo "$user:$NEW_PASSWORD" | chpasswd
        echo "[$(date)] Password changed for user: $user" >> $LOG_FILE
    fi
done

echo "[$(date)] Password rotation complete." >> $LOG_FILE
