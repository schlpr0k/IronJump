#!/bin/bash
# Bastion Device Management with SSH Key Update

BASTION_GROUP="bastion_devices"
USER_HOME_BASE="/home"

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or with sudo privileges."
    exit 1
fi

echo "Choose an option:"
echo "1. Register a new downstream bastion device"
echo "2. Delete a downstream bastion device"
echo "3. Disable a device"
echo "4. Enable a device"
echo "5. Update SSH key for a bastion device"
echo "6. List all registered devices"
read -p "Enter choice: " CHOICE

case $CHOICE in
    1)
        DEVICE_ID=$(generate_device_id)
        echo "Assigning device ID: $DEVICE_ID"

        # Prompt for ed25519 public key
        read -p "Paste the device's ed25519 SSH public key (OpenSSH format): " DEVICE_PUBLIC_KEY

        # Ensure ed25519 key format
        if [[ ! "$DEVICE_PUBLIC_KEY" =~ ^ssh-ed25519 ]]; then
            echo "Error: Public key must be of type ed25519."
            exit 1
        fi

        # Create device user
        useradd -m -g $BASTION_GROUP -s /sbin/nologin "$DEVICE_ID"

        # Configure SSH key for authentication
        DEVICE_HOME="$USER_HOME_BASE/$DEVICE_ID"
        SSH_DIR="$DEVICE_HOME/.ssh"
        AUTH_KEYS="$SSH_DIR/authorized_keys"

        mkdir -p "$SSH_DIR"
        echo "$DEVICE_PUBLIC_KEY" > "$AUTH_KEYS"
        chown -R "$DEVICE_ID:$DEVICE_ID" "$SSH_DIR"
        chmod 700 "$SSH_DIR"
        chmod 600 "$AUTH_KEYS"

        echo "Device $DEVICE_ID registered successfully."
        ;;
    2)
        read -p "Enter device ID to delete: " DEVICE_ID
        if id "$DEVICE_ID" &>/dev/null; then
            userdel -r "$DEVICE_ID"
            echo "Device $DEVICE_ID deleted."
        else
            echo "Error: Device $DEVICE_ID does not exist."
        fi
        ;;
    3)
        read -p "Enter device ID to disable: " DEVICE_ID
        usermod -L "$DEVICE_ID"
        echo "Device $DEVICE_ID disabled."
        ;;
    4)
        read -p "Enter device ID to enable: " DEVICE_ID
        usermod -U "$DEVICE_ID"
        echo "Device $DEVICE_ID enabled."
        ;;
    5)
        read -p "Enter device ID to update SSH key: " DEVICE_ID
        if id "$DEVICE_ID" &>/dev/null; then
            read -p "Paste the new ed25519 SSH public key: " NEW_KEY

            # Ensure ed25519 key format
            if [[ ! "$NEW_KEY" =~ ^ssh-ed25519 ]]; then
                echo "Error: Public key must be of type ed25519."
                exit 1
            fi

            DEVICE_HOME="$USER_HOME_BASE/$DEVICE_ID"
            AUTH_KEYS="$DEVICE_HOME/.ssh/authorized_keys"

            echo "$NEW_KEY" > "$AUTH_KEYS"
            chown "$DEVICE_ID:$DEVICE_ID" "$AUTH_KEYS"
            chmod 600 "$AUTH_KEYS"

            echo "Updated SSH key for device $DEVICE_ID."
        else
            echo "Error: Device $DEVICE_ID does not exist."
        fi
        ;;
    6)
        echo "Registered bastion devices:"
        getent group "$BASTION_GROUP" | awk -F: '{print $4}'
        ;;
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac
