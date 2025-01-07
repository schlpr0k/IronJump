#!/bin/bash
# Bastion User Management with SSH Key Update

BASTION_GROUP="bastion"
USER_HOME_BASE="/home"

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or with sudo privileges."
    exit 1
fi

echo "Choose an option:"
echo "1. Add a new bastion user (Requires ed25519 SSH public key)"
echo "2. Delete a bastion user"
echo "3. Disable a bastion user"
echo "4. Enable a bastion user"
echo "5. Update SSH key for a bastion user"
echo "6. List all bastion users"
read -p "Enter choice: " CHOICE

case $CHOICE in
    1)
        read -p "Enter first name: " FIRST_NAME
        read -p "Enter last name: " LAST_NAME
        read -p "Enter username: " USERNAME

        # Prompt for ed25519 public key
        read -p "Paste the user's ed25519 SSH public key (OpenSSH format): " PUBLIC_KEY

        # Ensure ed25519 key format
        if [[ ! "$PUBLIC_KEY" =~ ^ssh-ed25519 ]]; then
            echo "Error: Public key must be of type ed25519."
            exit 1
        fi

        # Create the user
        useradd -m -g $BASTION_GROUP -s /sbin/nologin -c "$FIRST_NAME $LAST_NAME" $USERNAME

        # Configure SSH key for authentication
        USER_HOME="$USER_HOME_BASE/$USERNAME"
        SSH_DIR="$USER_HOME/.ssh"
        AUTH_KEYS="$SSH_DIR/authorized_keys"

        mkdir -p "$SSH_DIR"
        echo "$PUBLIC_KEY" > "$AUTH_KEYS"
        chown -R "$USERNAME:$USERNAME" "$SSH_DIR"
        chmod 700 "$SSH_DIR"
        chmod 600 "$AUTH_KEYS"

        echo "User $USERNAME added and SSH key registered."
        ;;
    2)
        read -p "Enter username to delete: " USERNAME
        userdel -r "$USERNAME"
        echo "User $USERNAME deleted."
        ;;
    3)
        read -p "Enter username to disable: " USERNAME
        usermod -L "$USERNAME"
        echo "User $USERNAME disabled."
        ;;
    4)
        read -p "Enter username to enable: " USERNAME
        usermod -U "$USERNAME"
        echo "User $USERNAME enabled."
        ;;
    5)
        read -p "Enter username to update SSH key: " USERNAME
        if id "$USERNAME" &>/dev/null; then
            read -p "Paste the new ed25519 SSH public key: " NEW_KEY

            # Ensure ed25519 key format
            if [[ ! "$NEW_KEY" =~ ^ssh-ed25519 ]]; then
                echo "Error: Public key must be of type ed25519."
                exit 1
            fi

            USER_HOME="$USER_HOME_BASE/$USERNAME"
            AUTH_KEYS="$USER_HOME/.ssh/authorized_keys"

            echo "$NEW_KEY" > "$AUTH_KEYS"
            chown "$USERNAME:$USERNAME" "$AUTH_KEYS"
            chmod 600 "$AUTH_KEYS"

            echo "Updated SSH key for user $USERNAME."
        else
            echo "Error: User $USERNAME does not exist."
        fi
        ;;
    6)
        echo "Bastion users:"
        getent group $BASTION_GROUP | awk -F: '{print $4}'
        ;;
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac
