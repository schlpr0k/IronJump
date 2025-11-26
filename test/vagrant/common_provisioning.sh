#!/bin/bash

echo "========= START Updating install_devices to fix grub-pc error on debian based VMs ========="
# Set grub install device for grub-pc updates
# Find the partition grub is on (tail cuz can't surpress header), trim
# off the partition ID so we have just the disk, and make sure just one
boot_disk=$( df --output=source /boot/grub | tail -n1 | grep --color=no -m1 -o "[^0-9]*" | head -n1 )
echo "grub-pc grub-pc/install_devices multiselect $boot_disk" | debconf-set-selections -v
echo "========= END Updating install_devices to fix grub-pc error on debian based VMs ========="

echo "========= START Running apt update and upgrade ========="
# Non-interactive apt flags
export DEBIAN_FRONTEND=noninteractive
# https://debian-handbook.info/browse/stable/sect.package-meta-information.html#sidebar.questions-conffiles
# Use default confs or old confs
apt_dpkg_opts="-o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\""

apt-get update
apt-get --yes "${apt_dpkg_opts}" upgrade
echo "========= END Running apt update and upgrade ========="

# NOTE: Cannot use synced_folder to /opt/IronJump due to ironjump.role file
# needed for both server and endpoint which will stomp on each other for testing
IRONJUMP_HOME=/opt/IronJump
echo "========= START Copy IronJump files to ${IRONJUMP_HOME} ========="
set -x
mkdir --parents "${IRONJUMP_HOME}"
cd /vagrant || exit
cp -r ./*.sh autossh README.md LICENSE "${IRONJUMP_HOME}/"
set +x
echo "========= END Copy IronJump files to ${IRONJUMP_HOME} ========="
