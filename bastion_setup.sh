#!/bin/bash
# Bastion SSH Configuration with Key Enforcement

CONFIG_FILE="/etc/ssh/sshd_config"
BAK_FILE="/etc/ssh/sshd_config.bak.$(date +%F-%H%M%S)"
BASTION_DIR="/chroot/bastion"
BASTION_GROUP="bastion"

# Ensure script is run as root or sudo
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or with sudo privileges."
    exit 1
fi

# Backup existing SSH configuration
if [[ -f $CONFIG_FILE ]]; then
    cp $CONFIG_FILE $BAK_FILE
    echo "Backup of SSH config created at: $BAK_FILE"
fi

# Display and confirm SSH changes
echo "Proposed SSH Configuration:"
cat <<EOF

Match Group $BASTION_GROUP
    ChrootDirectory $BASTION_DIR
    ForceCommand /bin/false
    PermitTTY no
    AllowTcpForwarding yes
    GatewayPorts yes
    PermitTunnel yes
    AuthenticationMethods publickey
    PubkeyAcceptedKeyTypes ssh-ed25519
    PasswordAuthentication no
EOF

read -p "Do you accept these changes? (yes/no): " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
    echo "Configuration aborted."
    exit 1
fi

# Apply SSH configuration
echo "Configuring SSH service..."
cat <<EOF >> $CONFIG_FILE

Match Group $BASTION_GROUP
    ChrootDirectory $BASTION_DIR
    ForceCommand /bin/false
    PermitTTY no
    AllowTcpForwarding yes
    GatewayPorts yes
    PermitTunnel yes
    AuthenticationMethods publickey
    PubkeyAcceptedKeyTypes ssh-ed25519
    PasswordAuthentication no
EOF

# Create chroot directory
mkdir -p $BASTION_DIR
chown root:root $BASTION_DIR
chmod 755 $BASTION_DIR

# Restart SSH service
echo "Restarting SSH service..."
systemctl restart sshd

echo "Bastion SSH configuration with ed25519 key enforcement complete."
