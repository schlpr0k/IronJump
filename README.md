<center>![image](https://github.com/user-attachments/assets/44469293-e15e-481a-940f-5f70e1cbc061)</center>

# IronJump SSH Bastion Administration Guide
IronJump is a lightweight, menu-driven SSH bastion system designed for administrators, consultants, penetration testers, red teams, blue teams, and incident responders. It simplifies the deployment of physical or virtual bastion hosts, automates the setup and management of SSH tunnels, and provides a structured access control management system.

## Installation
> [!NOTE]
> The IronJump package is a self-contained package for deploying the IronJump Server [the Root Server] and Endpoint Devices [Ingots].
> 
> From the IronJump menu:
> * Option 1: Root Server Management - Use create user and endpoint accounts
> * Option 2: Endpoint Device Account Management - Use to setup and manage the connection to a Root Server
> * Option 3: Access Control Management - Allow or Revoke users access to endpoint

### Download and Install IronJump
```
cd /opt/
git clone --recurse-submodules https://github.com/IronJump/IronJump.git
cd IronJump
chmod +x IronJump.sh
```
> [!IMPORTANT]
> 1. IronJump Endpoints rely on AutoSSH make sure to use "--recurse-submodules" when cloning this project.
>      * If you cloned this repository without that option and you autossh directory appears empty. run 'git submodule update --init'
> 3. IronJump must be installed in /opt/IronJump to run correctly.

## Setting up the IronJump Bastion Server
1. Run IronJump.sh with root privileges:
```
sudo /opt/IronJump/IronJump.sh
```
2. Deploy the IronJump Bastion Server

* From the Main Menu, navigate to Root Server Management > Configuration & Deployment Management > Deploy an IronJump Root Server.
* Follow the guided prompts to configure the server, including:
  * Backing up existing SSH configurations
  * Rotating SSH keys
  * Setting up security policies

> [!NOTE]
> Required dependencies (OpenSSH Server, OpenSSH Client, Cron) are automatically installed.

### Registering and Configuring Endpoints
> [!NOTE]
> Endpoints are labeled as 'ingots' within IronJump.
> You may see references in this documentation to Endpoints Devices as 'hosts, ingots, or an endpoint accounts. For clarity, please understand that for automated management of access controls and SSH connections, the hostname of the endpoint must be identical to an account registered on the IronJump server.
> Example:
> * IronJump Server - Endpoint Account on : ingot-50000
> * Endpoint Hostname: ingot-50000

> [!IMPORTANT]
> Before registration, use the IronJump Server to first create an Endpoint Account

### Initiate Endpoint Registration

1. From the Main Menu, select Endpoint Device Management > Connect to IronJump Server.
2. Provide the necessary details:
  * IronJump Server IP
  * Assigned Hostname
  * One-Time Password

3. Automatic Setup
* The system will install necessary dependencies: OpenSSH Server & Client, Make, GCC, and Cron.
* AutoSSH is included in the IronJump package and will be installed automatically.
* The endpoint's hostname will be converted to ingot-##### where ##### is an assigned port number (50000–59999) for reverse SSH tunnels.
* Automated Access Control Synchronization
* A cron job runs every 5 minutes to pull the latest Access Control rules and SSH keys from the server
* The system will then reboot and establish a connection to the IronJump Server
