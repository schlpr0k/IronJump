#!/bin/bash
# Setup Cron Jobs for SSH Monitoring and Password Rotation

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or with sudo privileges."
    exit 1
fi

echo "Setting up cron jobs..."

# Password rotation every 8 hours
echo "0 */8 * * * root /bin/bash /usr/local/bin/bastion_password_rotation.sh" > /etc/cron.d/bastion_password_rotation

# SSH service monitor every 10 minutes
echo "*/10 * * * * root /bin/bash /usr/local/bin/bastion_service_monitor.sh" > /etc/cron.d/bastion_service_monitor

# Apply correct permissions
chmod 644 /etc/cron.d/bastion_password_rotation
chmod 644 /etc/cron.d/bastion_service_monitor

echo "Cron jobs set up successfully."
