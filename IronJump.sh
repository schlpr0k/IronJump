#!/bin/bash
# IronJump.sh - Unified Bastion Server & Endpoint Management Script
# Authors: Andrew Bindner & Carlota Bindner
# Purpose: Configure, deploy and manage IronJump Bastion Server and Endpoints
# Version: 0.1-Beta
# License: Private

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or with sudo privileges."
    exit 1
fi

# Check for config file
if [[ -f $(echo $(pwd)/CONFIG.FILE) ]]; then
    source ./CONFIG.FILE
else
    echo "CONFIG.FILE must be in the working directory to continue."
    exit 1
fi

# FUNCTIONS
source ./FUNCTIONS

### Menu Construction ###
nav_top() {
    echo -e "========================================================\r\n"
}

nav_foot() {
    echo -e "\r\n--------------------------------------------------------"
    echo -e "P. Previous Menu"
    echo -e "Q. Quit\r\n"
    read -p "Enter your choice: " choice
}

# Main Menu
main_menu() {
    clear
    echo "IronJump SSH Management"
    nav_top
    f_os_identity
    echo "1. Deploy an IronJump Bastion Server"
    echo "2. Bastion User Account Management"
    echo "3. Endpoint and Downstream Bastion Account Management"
    echo "4. Endpoint Configuration and Deployment"
    echo "5. SSH Monitor Console"
    echo -e "\r\n--------------------------------------------------------"
    echo "R. Reboot Server"
    echo -e "Q. Quit\r\n"
    read -p "Enter your choice: " choice
    case "$choice" in
        1) deployment_menu ;;
        2) usr_acct_mgmt_menu ;;
        3) dev_acct_mgmt_menu ;;
        4) ep_mgmt_menu ;;
        5) ssh_monitor ;;
        R|r) ast_reboot ;;
        Q|q) exit 0 ;;
        *) invalid_choice ; main_menu ;;
    esac
}

# 1. Deploy an IronJump Bastion Server Menu (deployment_menu)
deployment_menu() {
    clear
    echo "Bastion Deployment"
    nav_top
    echo "1. Deploy an IronJump Bastion Server (Root / Upstream)"
    echo "2. Deploy an IronJump Bastion Server (Secondary / Downstream)"
    echo "3. Veiw Current Configuration for this Server"
    echo "4. Modify Current Configuration for this Server (Opens VI Editor)"
    echo "5. Harden or Modify SSH Service on this Server (Standalone Utility)"
    nav_foot
    case "$choice" in
        1) deploy_root ;;
        2) deploy_secondary ;;
        3) view_configuration ;;
        4) mod_configuration ;;
        5) harden_ssh_service ; deployment_menu ;;
        R|r) ast_reboot ;;
        P|p) main_menu ;;
        Q|q) exit 0 ;;
        *) invalid_choice ; deployment_menu ;;
    esac
}

# 2. User Account Management Menu (usr_acct_mgmt_menu)
usr_acct_mgmt_menu() {
    clear
    echo "Bastion User Management"
    nav_top
    echo "1. List Current Bastion User Accounts"
    echo "2. Create New Bastion User Account"
    echo "3. Enable Bastion User Account"
    echo "4. Disable Existing Bastion User Account"
    echo "5. Delete Existing Bastion User Account"
    echo "6. Change a Bastion User's SSH Public Key"
    echo "7. Set Epiration of a Bastion User's Account"
    nav_foot
    case "$choice" in
        1) usr_mgmt_list ;;
        2) usr_mgmt_new ;;
        3) usr_mgmt_enable ;;
        4) usr_mgmt_disable ;;
        5) usr_mgmt_delete ;;
        6) usr_mgmt_mod_pubkey ;;
        7) usr_mgmt_set_expire ;;
        R|r) ast_reboot ;;
        P|p) main_menu ;;
        Q|q) exit 0 ;;
        *) invalid_choice ;usr_acct_mgmt_menu ;;
    esac
}

# 3. Endpoint and Downstream Bastion Account Management (dev_acct_mgmt_menu)
dev_acct_mgmt_menu() {
    clear
    echo "Bastion Endpoint & Downstream Device Account  Management"
    nav_top
    echo "1. List Current Bastion Device Accounts"
    echo "2. Create New Bastion Device Account"
    echo "3. Enable New Bastion Device Account"
    echo "4. Disable Existing Bastion Device Account"
    echo "5. Delete Existing Bastion Device Account"
    echo "6. Change an Endpoint or Downstream Device's SSH Public Key"
    echo "7. Set Epiration of an Endpoint or Downstream Device's Account"
    nav_foot
    case "$choice" in
        1) dev_mgmt_list ;;
        2) dev_mgmt_new ;;
        3) dev_mgmt_enable ;;
        4) dev_mgmt_disable ;;
        5) dev_mgmt_delete ;;
        6) dev_mgmt_mod_pubkey ;;
        7) dev_mgmt_set_expire ;;
        R|r) ast_reboot ;;
        P|p) main_menu ;;
        Q|q) exit 0 ;;
        *) invalid_choice ; dev_acct_mgmt_menu ;;
    esac
}


# 4. Endpoint Configuration and Deployment Menu (ep_mgmt_menu)
ep_mgmt_menu() {
    clear
    echo "Bastion Endpoint & Downstream Device Account Management"
    nav_top
    echo "!! NOTE: This menu is for convenient management of an endpoint only and meant"
    echo -e "\t    meant to help with the setup and integrate with IronJump bastions."
    echo "!! NOTE: Use this menu to create user and endpoint or downstream server accounts."
    echo -e "\t - Create the host's SSH public and private keys, then use the public key"
    echo -e "\t   and same account name on the root and/or upstream server(s)."
    echo -e "\t - Endpoints and downstream servers SSH keys DO NOT have a passphrase."
    echo -e "\t - User created here will have a full shell to the endpoint. Unlike"
    echo -e "\t   upstream or downstream bastion servers, user's passwords not reset"
    echo -e "\t   on this server."
    nav_top
    echo "1. Connect to a Root or Upstream IronJump Bastion Server (Only Works on Linux)"
    echo "2. Add a Local SSH-enabled User Account"
    echo "3. Promote a Local User to the sudoers, sudo, admin, and wheel Groups"
    echo "4. Enable a Local User Account"
    echo "5. Disable a Local User Account"
    echo "6. Set Expiration for Local User Account"
    echo "7. Change Password for Local User Account"
    echo "8. Change SSH Public Key for Local User Account"
    echo "9. Delete a Local User Account"
    echo "D. SMELT this Host!"
    echo -e "\t   (Wipe all data, destroy this host, and shutdown the machine)"
    echo -e "\t   !! PROCESS IS NOT REVERSABLE !!"
    nav_foot
    case "$choice" in
        1) ep_connect ;;
        2) ep_add_local_usr ;;
        3) ep_promote_local_usr ;;
        4) ep_enable_local_usr ;;
        5) ep_disable_local_usr ;;
        6) ep_expire_local_usr ;;
        7) ep_chpass_local_usr ;;
        8) ep_mod_local_usr_pubkey ;;
        9) ep_delete_local_usr ;;
        D|d) ep_smelt_device ;;
        R|r) ast_reboot ;;
        P|p) main_menu ;;
        Q|q) exit 0 ;;
        *) invalid_choice ; ep_mgmt_menu ;;
    esac
}


# Execut IronJump Script
main_menu
