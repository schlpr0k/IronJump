<img width="288" height="288" alt="image" src="https://github.com/user-attachments/assets/ffc8c468-1b41-428f-84df-31aabde190bc" />

# IronJump SSH Bastion Administration Guide

IronJump is a lightweight, menu-driven SSH bastion system designed for administrators, consultants, penetration testers, red teams, blue teams, and incident responders. It simplifies the deployment of physical or virtual bastion hosts, automates the setup and management of SSH tunnels, and provides a structured access control management system.

## Table of Contents

* [Installation](#installation)
  * [Download IronJump](#download-ironjump)
  * [Install IronJump](#install-ironjump)
* [Set-up IronJump](#set-up-ironjump)
  * [Setting up the IronJump Bastion Server](#setting-up-the-ironjump-bastion-server)
  * [Setting up IronJump Endpoints](#setting-up-ironjump-endpoints)
    * [Endpoint Device Account Creation](#endpoint-device-account-creation)
    * [Initiate Endpoint Registration](#initiate-endpoint-registration)
* [User Account Management](#user-account-management)
  * [Adding a New User](#adding-a-new-user)
* [Access Control Management](#access-control-management)

## Installation

IronJump is a self-contained package for deploying the IronJump Server (aka the Root Server) and Endpoint Devices (aka Ingots).

> [!IMPORTANT]
> Download and Install needs to be done on both your Bastion server and Endpoint.

### Download IronJump

> [!IMPORTANT]
>
> 1. IronJump must be installed in `/opt/IronJump` to run correctly.
> 2. IronJump Endpoints rely on AutoSSH, so make sure to use "--recurse-submodules" when cloning this project.
>    * If you cloned this repository without that option and the `autossh` directory is empty, run `git submodule update --init` from the `/opt/IronJump` directory.

1. Download IronJump by cloning this repository and its submodules to `/opt/IronJump`.

   ```bash
   git clone --recurse-submodules https://github.com/schlpr0k/IronJump.git /opt/IronJump
   ```

### Install IronJump

1. Run IronJump.sh with root privileges:

   ```bash
   sudo /opt/IronJump/IronJump.sh
   ```

> [!NOTE]
> This will add `ironjump` to the `$PATH`, but IronJump will not be ready for use until you set-up the system as a Bastion server or Endpoint (see next sections).

## Set-up IronJump

The IronJump menu has a few simple options:

* Option 1: Root Server Management - Use create user and endpoint accounts
* Option 2: Endpoint Device Account Management - Use to setup and manage the connection to a Root Server
* Option 3: Access Control Management - Allow or Revoke users access to endpoint

### Setting up the IronJump Bastion Server

> [!NOTE]
> Required dependencies (OpenSSH Server, OpenSSH Client, Cron) are automatically installed during this set-up.

1. On the system that will be the Bastion server, start IronJump, if it is not already running:

   ```bash
   sudo ironjump
   ```

2. From the Main Menu, select `Root Server Management` > `Configuration & Deployment Management` > `Deploy an IronJump Root Server`.

3. Follow the guided prompts to configure the server, which will:
    * Back up existing SSH configurations
    * Perform SSH hardening
    * Rotate SSH keys
    * Set up security policies

### Setting up IronJump Endpoints

Endpoints are labeled as `ingots` within IronJump. You may see references in this documentation to Endpoints Devices as `hosts`, `ingots`, `jumpbox` or `endpoint accounts`.

> [!NOTE]
> For automated management of access controls and SSH connections, the hostname of the endpoint must be identical to an account registered on the IronJump server, which is why when set-up is run on an endpoint, the hostname will be modified.
>
> Example:
>
>* IronJump Server: List Endpoint Accounts: ingot-50000
>* Endpoint Hostname: ingot-50000

#### Endpoint Device Account creation

1. On the Bastion server, start IronJump, if it is not already running:

   ```bash
   sudo /opt/IronJump/IronJump.sh || sudo ironjump
   ```

2. From the Main Menu, select `Root Server Management` > `Endpoint Device Account Management` > `Create New Endpoint Device Account`.

3. In the _New Endpoint Account Creation_ screen, supply a description for the endpoint that will be recognizable later.

4. From the _New Endpoint Account (Credentials)_ screen, write down the `Endpoint account name` and `One-time Password`. These will be used to connect the endpoint to the server.
<!-- markdownlint-disable-next-line blanks-around-lists -->
> [!WARNING]
> If you do not write down this information, you will need to repeat these steps before continuing!
<!-- markdownlint-disable ol-prefix -->
5. Press ENTER to complete the server-side endpoint creation.

6. At the top of the menu is details about the IronJump server. Write down the IP Address, as it will be necessary later.
<!-- markdownlint-enable ol-prefix -->

#### Initiate Endpoint Registration

1. On the new endpoint, start IronJump, if it is not already running:

   ```bash
   sudo /opt/IronJump/IronJump.sh || sudo ironjump
   ```

2. From the Main Menu, select `Endpoint Device Management` > `Connect to IronJump Server`.

3. Provide the necessary details:
   * IronJump Server IP
   * Endpoint account name
   * One-Time Password

4. Follow the prompts and enter the one-time password when prompted.
 
5. Automatic Setup will be performed, which will:
   * Install necessary dependencies: OpenSSH Server & Client, Make, GCC, and Cron
   * Install the included AutoSSH
   * Change the hostname to `ingot-#####` where `#####` is the assigned port number (50000–59999) for the bastion's reverse SSH tunnels
   * Automate Access Control Synchronization
   * Configure a cron job to run every 5 minutes to pull the latest Access Control rules and SSH keys from the server

7. Press ENTER to reboot the system to establish a connection to the IronJump Server.

## User Account Setup

<!-- markdownlint-configure-file
{
  "line-length": false,
  "no-inline-html": false
}
-->
