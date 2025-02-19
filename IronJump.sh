#!/bin/bash
# IronJump.sh - Unified Bastion Server & Endpoint Management Script
# Authors: Andrew Bindner & Carlota Bindner
# Purpose: Configure, deploy, and manage IronJump Bastion Server and Endpoints
# Version: 0.1-Beta
# License: Private

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or with sudo privileges."
    exit 1
fi

#Save current directory and Migrate to IronJump working directory
if [[ ! -f /opt/IronJump/IronJump.sh ]]; then
    echo "The IronJump application and associated scripts must be located in /opt/IronJump folder. Please move IronJump and relaunch the application."
    exit 1
else
    OLDPWD=$(pwd)
    SCRIPT_DIR="/opt/IronJump"
    cd $SCRIPT_DIR
fi

# Check for CONFIG.FILE file
if [[ -f ./CONFIG.FILE ]]; then
    source ./CONFIG.FILE
else
    echo "CONFIG.FILE must be in the working directory to continue."
    exit 1
fi

# Check for FUNCTIONS file
if [[ -f ./FUNCTIONS ]]; then
    source ./FUNCTIONS
else
    echo "FUNCTIONS file must be in the working directory to continue."
    exit 1
fi

### Menu Construction ###
nav_top_bar() {
    echo -e "========================================================\r\n"
}

nav_breaker_bar() {
    echo -e "\r\n--------------------------------------------------------"
}

nav_head_menu(){
    clear
    echo "IronJump SSH Management"
    nav_top_bar
    f_os_identity
    nav_top_bar

}

nav_foot_menu() {
    echo -e "S. SSH Monitor Live Connections"
    echo -e "P. Previous Menu"
    echo -e "R. Reboot Server"
    echo -e "Q. Quit\r\n"
    read -p "Enter your choice: " choice
}

# Main Menu
main_menu() {
    nav_head_menu
    echo "Navigation:"
    echo -e "--> Main Menu\r\n"
    echo -e "Menu Selection:\n"
    echo "1. Root Server Management"
    echo "2. Endpoint Device Management"
    echo "3. Access Control Management"
    nav_breaker_bar
    echo "S. SSH Monitor Live Connections"
    echo "R. Reboot Server"
    echo -e "Q. Quit\r\n"
    read -p "Enter your choice: " choice
    case "$choice" in
        1) root_server_mgmt_menu ; main_menu ;;
        2) endpoint_device_mgmt_menu ; main_menu ;;
        3) access_control_mgmt_menu ; main_menu ;;
        S|s) ssh_monitor ;;
        R|r) ast_reboot ;;
        Q|q) cd $OLDPWD ; exit 0 ;;
        *) invalid_choice ; main_menu ;;
    esac
}

#Root Server Management Menu
root_server_mgmt_menu() {
    clear
    nav_head_menu
    echo "Navigation:"
    echo -e "--> Main Menu"
    echo -e "   --> Root Server Management\r\n"
    echo -e "Menu Selection:\n"
    echo "1. Configuration & Deployment Management"
    echo "2. User Account Management"
    echo "3. Endpoint Device Account Management"
    nav_breaker_bar
    nav_foot_menu
    case $choice in
        1) root_server_config_deploy_mgmt_menu ;;
        2) root_server_user_acct_mgmt_menu ;;
        3) root_server_endpoint_acct_mgmt_menu ;;
        S|s) ssh_monitor ;;
        R|r) ast_reboot ;;
        P|p) main_menu ;;
        Q|q) cd $OLDPWD ; exit 0 ;;
        *) invalid_choice; root_server_mgmt_menu ;;
    esac
}

root_server_config_deploy_mgmt_menu() {
    clear
    nav_head_menu
    echo "Navigation:"
    echo -e "--> Main Menu"
    echo -e "   --> Root Server Management"
    echo -e "      --> Configuration & Deployment Menu\r\n"
    echo -e "Menu Selection:\n"
    echo "1. View Configuration File"
    echo "2. Modify Configuration File (Opens VI Editor)"
    echo "3. Deploy an IronJump Root Server"
    echo "H. Harden SSH Service (Standalone Utility)"
    nav_breaker_bar
    nav_foot_menu
    case $choice in
        1) view_configuration ;;
        2) mod_configuration ;;
        3) f_setup_ironjump ; main_menu ;;
        H|h) harden_ssh_service ; main_menu ;;
        S|s) ssh_monitor ;;
        R|r) ast_reboot ;;
        P|p) root_server_mgmt_menu ;;
        Q|q) cd $OLDPWD ; exit 0 ;;
        *) invalid_choice; root_server_config_deploy_mgmt_menu ;;
    esac
}

root_server_user_acct_mgmt_menu() {
    clear
    nav_head_menu
    echo "Navigation:"
    echo -e "--> Main Menu"
    echo -e "   --> Root Server Management"
    echo -e "      --> User Account Management Menu\r\n"
    echo -e "Menu Selection:\n"
    echo "1. List Current IronJump User Accounts"
    echo "2. Create New IronJump User Account"
    echo "3. Enable IronJump User Account"
    echo "4. Disable Existing IronJump User Account"
    echo "5. Delete Existing IronJump User Account"
    echo "6. Change a IronJump User's SSH Public Key"
    echo "7. Set Expiration of a IronJump User's Account"
    nav_breaker_bar
    nav_foot_menu
    case $choice in
        1) usr_mgmt_list ;;
        2) usr_mgmt_new ;;
        3) usr_mgmt_enable ;;
        4) usr_mgmt_disable ;;
        5) usr_mgmt_delete ;;
        6) usr_mgmt_mod_pubkey ;;
        7) usr_mgmt_set_expire ;;
        S|s) ssh_monitor ;;
        R|r) ast_reboot ;;
        P|p) root_server_mgmt_menu ;;
        Q|q) cd $OLDPWD ; exit 0 ;;
        *) invalid_choice ; root_server_user_acct_mgmt_menu ;;
    esac
}

root_server_endpoint_acct_mgmt_menu() {
    clear
    nav_head_menu
    echo "Navigation:"
    echo -e "--> Main Menu"
    echo -e "   --> Root Server Management"
    echo -e "      --> Endpoint Device Account Management Menu\r\n"
    echo -e "Menu Selection:\n"
    echo "1. List Current Endpoint Device Accounts"
    echo "2. Create New Endpoint Device Account"
    echo "3. Enable New Endpoint Device Account"
    echo "4. Disable Existing Endpoint Device Account"
    echo "5. Delete Existing Endpoint Device Account"
    echo "6. Change an Endpoint Device's SSH Public Key"
    echo "7. Set Expiration of an Endpoint Device's Account"
    nav_breaker_bar
    nav_foot_menu
    case $choice in
        1) dev_mgmt_list ; root_server_endpoint_acct_mgmt_menu ;;
        2) dev_mgmt_new ; root_server_endpoint_acct_mgmt_menu ;;
        3) dev_mgmt_enable ;;
        4) dev_mgmt_disable ;;
        5) dev_mgmt_delete ;;
        6) dev_mgmt_mod_pubkey ;;
        7) dev_mgmt_set_expire ;;
        S|s) ssh_monitor ;;
        R|r) ast_reboot ;;
        P|p) root_server_mgmt_menu ;;
        Q|q) cd $OLDPWD ; exit 0 ;;
        *) invalid_choice ; root_server_endpoint_acct_mgmt_menu ;;
    esac
}


#Endpoint Device Management Menu
endpoint_device_mgmt_menu() {
    clear
    nav_head_menu
    echo "Navigation:"
    echo -e "--> Main Menu"
    echo -e "   --> Endpoint Device Management Menu\r\n"
    echo -e "Menu Selection:\n"
    echo "1. Connect to IronJump Server (Only works on Linux & Mac)"
    echo "2. Force an unscheduled permissions sync"
    echo "3. Harden SSH Service on this Endpoint (Standalone Utility)"
    echo -e "D. SMELT this endpoint (Full Destruction - Not Recoverable)\r\n"
    nav_breaker_bar
    nav_foot_menu
    case $choice in
        1) ep_connect ;;
        2) ep_force_sync ;;
        3) harden_ssh_service ; main_menu ;;
        D|d) ep_smelt_dev ;;
        S|s) ssh_monitor ;;
        R|r) ast_reboot ;;
        P|p) main_menu ;;
        Q|q) cd $OLDPWD ; exit 0 ;;
        *) invalid_choice ; endpoint_device_mgmt_menu ;;
    esac
}

#Access Control Management Menu
access_control_mgmt_menu() {
    clear
    nav_head_menu
    echo -e "Navigation:"
    echo -e "-->Main Menu"
    echo -e "   -->Access Control Management Menu\r\n"
    echo -e "Menu Selection:\n"
    echo "1. Assign User to Endpoint"
    echo "2. Revoke User from Endpoint"
    echo "3. List Current User/Endpoint Assignments"
    nav_breaker_bar
    nav_foot_menu
    case $choice in
        1) access_control_assign_user ;;
        2) access_control_revoke_user ;;
        3) access_control_list_assignments ;;
        S|s) ssh_monitor ;;
        R|r) ast_reboot ;;
        P|p) main_menu ;;
        Q|q) cd $OLDPWD ; exit 0 ;;
        *) invalid_choice ; access_control_mgmt_menu ;;
    esac
}

access_control_assign_user() {
    clear
    echo -e "Access Control Management - Assign a User"
    nav_top_bar
    echo -e "\nNavigation:"
    echo -e "-->Main Menu"
    echo -e "   -->Access Control Management Menu"
    echo -e "      --> Assign a User\r\n"
    echo -e "Menu Selection:\n"
    echo "1. View & Add Assignments by User"
    echo "2. View & Add Assignments by Endpoint"
    nav_breaker_bar
    nav_foot_menu
    case $choice in
        1) assignments_add_by_user ;;
        2) assignments_add_by_endpoint ;;
        S|s) ssh_monitor ;;
        R|r) ast_reboot ;;
        P|p) access_control_mgmt_menu ;;
        Q|q) cd $OLDPWD ; exit 0 ;;
        *) invalid_choice ; access_control_assign_user ;;
    esac
}

access_control_revoke_user() {
    clear
    echo -e "Access Control Management - Revoke a User"
    nav_top_bar
    echo -e "\nNavigation:"
    echo -e "-->Main Menu"
    echo -e "   -->Access Control Management Menu"
    echo -e "      --> Revoke a User\r\n"
    echo -e "Menu Selection:\n"
    echo "1. View & Revoke Assignments by User"
    echo "2. View & Revoke Assignments by Endpoint"
    nav_breaker_bar
    nav_foot_menu
    case $choice in
        1) assignments_revoke_by_user ;;
        2) assignments_revoke_by_endpoint ;;
        S|s) ssh_monitor ;;
        R|r) ast_reboot ;;
        P|p) access_control_mgmt_menu ;;
        Q|q) cd $OLDPWD ; exit 0 ;;
        *) invalid_choice ; access_control_revoke_user ;;
    esac
}

#Launch IronJump (__main__)
main_menu
