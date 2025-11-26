<img width="288" height="288" alt="image" src="https://github.com/user-attachments/assets/ffc8c468-1b41-428f-84df-31aabde190bc" />

# IronJump SSH Management Suite - Administrative Usage Guide

Welcome to **IronJump**, a hardened SSH bastion and endpoint management system built for IT, cybersecurity, and OT environments. This guide provides a detailed walkthrough for system administrators managing IronJump in real-world infrastructure deployments.

> [!TIP] 
> [Watch the BlackHat Arsenal Presentation!](https://drive.google.com/file/d/1U1EpI-Uat7-UnHyR0p_eApjEExXhrlDv/view?usp=sharing)

---

## Table of Contents

- [About IronJump](#about-ironjump)
  - [What is IronJump?](#what-is-ironjump)
  - [Why IronJump Matters](#why-ironjump-matters)
  - [Who Should Use This?](#who-should-use-this)
  - [Example Use Cases](#example-use-cases)
- [Getting Started](#getting-started)
  - [System Requirements](#system-requirements)
  - [Installation](#installation)
    - [Server](#server)
    - [Endpoint](#endpoint)
- [Root Server Management](#root-server-management)
  - [Configuration & Deployment Management](#configuration--deployment-management)
  - [User Account Management](#user-account-management)
  - [Endpoint Device Account Management](#endpoint-device-account-management)
- [Endpoint Device Management](#endpoint-device-management)
- [Access Control Management](#access-control-management)
  - [Assignments](#assignments)
  - [Mass Assignments & Revocation](#mass-assignments--revocation)
- [Change Role Type](#change-role-type)
- [System Utilities](#system-utilities)
- [Final Notes](#final-notes)
  - [Offline Deployments](#offline-deployments)

---

## About IronJump

### What is IronJump?
IronJump is a hardened SSH bastion and endpoint management framework written in Bash. It enables security professionals and administrators to securely deploy and maintain jump servers and endpoint devices across hybrid infrastructure including IT, OT, and remote systems, without relying on cloud-based access brokers or third-party dependencies. IronJump enforces strict access controls, simplifies SSH key management, and includes automated tooling to harden services, manage users, and facilitate secure reverse tunnels with autossh. It was built for environments that demand high trust, minimal overhead, and full operational control.

### Why IronJump Matters
Many organizations struggle to balance ease of access with strong security controls across distributed infrastructure. Traditional jump hosts are often misconfigured, overly permissive, or lack standardized deployment and management. IronJump solves this by offering a unified, role-driven management interface to handle both server and endpoint provisioning, all through a self-contained, auditable Bash framework.

IronJump reduces administrative complexity while increasing visibility, auditability, and control.

### Who Should Use This?
* Penetration testers setting up isolated, disposable bastions during engagements
* Security teams managing remote access to sensitive IT/OT networks
* DevOps engineers deploying SSH access for on-prem or hybrid systems
* Red teams managing access tiers and backhaul tunnels to compromised infrastructure
* Sysadmins replacing brittle, undocumented bastion setups with hardened automation

### Example Use Cases
1. **Secure Field Device Access**: Grant engineers temporary access to remote OT devices through a hardened central jump host with SSH key expiration.
2. **Penetration Test Infrastructure**: Deploy a temporary SSH bastion during an internal assessment to route traffic securely through controlled tunnels.
3. **Reverse Tunnel Access for Remote Linux Hosts**: Connect untrusted or roaming devices back to a central IronJump bastion for secure remote access.
4. **Tiered Administrator Management**: Assign unique SSH keys and expiration dates to different admin levels across critical endpoints.
5. **Incident Response Containment**: Rapidly deploy IronJump to isolate compromised hosts while maintaining controlled access for forensics.

## Getting Started

### System Requirements

IronJump is lightweight and can operate with minimum OS system requirements. The
following represents the suggested system requirements for running on Ubuntu.

* CPUs: 1
* Memory: 4GB
* Disk space: 10GB (If headless)

---
### Installation

> [!NOTE]
> - _This is the common set-up which needs to be done on Servers and Endpoints._
> - _The script **must be run as root** and placed inside `/opt/IronJump`._

1. Add IronJump to the system:
```bash
sudo git clone --recurse-submodules https://github.com/schlpr0k/IronJump.git /opt/IronJump
cd /opt/IronJump
sudo chmod +x IronJump.sh
```

2. Launch IronJump for the first time to create an `ironjump` symlink on the PATH:
```bash
sudo /opt/IronJump/IronJump.sh
```

---
#### Server

> [!NOTE]
> _See [Root Server Management](#root-server-management) for full details; the
following is just a QuickStart!_

1. Launch `ironjump` on the system which will act as the server:
```bash
sudo ironjump
```

2. Navigate thru the following Menu Options:
   - `1. Root Server Management`
   - `1. Configuration & Deployment Management`
   - `3. Deploy an IronJump Root Server` --> _This will begin deployment immediately!_

3. There will be several prompts during deployment; answer them appropriately.

4. When Server setup is complete, IronJump will return to the Main Menu.
   Navigate thru the following Menu Options to prepare the Server to accept an
   Endpoint connection:
   - `1. Root Server Management`
   - `3. Endpoint Device Account Management`
   - `2. Create New Endpoint Device Account`

5. When prompted, enter a description of the new endpoint.

6. Save the Endpoint account name and One-time Password!! _**They will not be
   shown again!**_

7. Save the Server IP Address at the top of the menu for use in connecting the Endpoint.

8. Continue to the [Endpoint](#endpoint) section to register an Endpoint.

---
#### Endpoint

> [!NOTE]
> _See [Endpoint Device Management](#endpoint-device-management) for full details;
the following is just a QuickStart!_

1. Launch `ironjump` on the system which will act as an endpoint:
```bash
sudo ironjump
```

2. Navigate thru the following Menu Options:
   - `2. Endpoint Device Management`
   - `1. Connect to IronJump Server`

3. When prompted, input:
   - Server IP Address
   - Endpoint account name
   - yes (_When asked IF you have the Endpoint password, this is NOT the place to input the password_)

4. Setup will continue and then display a confirmation page. Press ENTER to
   confirm the server and username are correct.

5. When prompted, input the one time password.

6. When Endpoint setup is complete, press ENTER to confirm reboot.

7. When the Endpoint host has rebooted, reconnect to the host and execute `sudo ironjump`.
   The `Role` should now be `ENDPOINT` and the `Hostname` should now be `ingot-XXXXX`.

8. Press `S` to view SSH Connections. In the `RAW VIEW` there should be an
   `ssh` connection established to the Server IP Address.

9. ON THE SERVER, within `ironjump`, press `S` to view SSH Connections. The top
   chart should contain an `ingot-XXXXX` user matching the Endpoint Hostname
   which was just connected.

---

## Root Server Management

Only available when the system role is set to `SERVER` or `HYBRID`.

### Configuration & Deployment Management

**Menu Path:** `Main Menu` → `Root Server Management` → `Configuration & Deployment`

- **1. View Configuration File**
  - Displays the IronJump config file in read-only mode.

- **2. Modify Configuration File**
  - Opens the config file using `vi`. Save changes with `:wq`

- **3. Deploy an IronJump Root Server**
  - Checks if the role is already `SERVER`. If not, runs the `f_setup_ironjump` function.

- **4. Generate Archive of Files & Logs**
  - Gathers logs, configuration, and SSH keys into a compressed archive.

- **H. Harden SSH Service**
  - Applies IronJump security standards to `sshd_config`

### User Account Management

**Menu Path:** `Root Server Management` → `User Account Management`

- **1. List Current IronJump Users**
- **2. Create New IronJump User**
- **3. Enable Existing User**
- **4. Disable User**
- **5. Delete User**
- **6. Change SSH Public Key**
- **7. Set Expiration for User Account**

Each function manages users in the `ironjump_users` group.

### Endpoint Device Account Management

**Menu Path:** `Root Server Management` → `Endpoint Device Account Management`

- **1. List Endpoint Accounts**
- **2. Create New Endpoint Account**
- **3. Enable Endpoint**
- **4. Disable Endpoint**
- **5. Delete Endpoint**
- **6. Change Endpoint SSH Key**
- **7. Set Endpoint Expiration Date**

---

## Endpoint Device Management

Only available when the role is `ENDPOINT` or `HYBRID`.

**Menu Path:** `Main Menu` → `Endpoint Device Management`

- **1. Connect to IronJump Server**
  - Registers endpoints. Will not proceed if already configured as `ENDPOINT`

- **2. Force Unscheduled Permissions Sync**
  - Syncs user/permission data with the root server manually

- **3. Generate Archive**
  - Gathers endpoint files, logs, and configuration

- **4. Harden SSH Service**
  - Applies SSH security configurations for endpoints

- **D. SMELT This Endpoint**
  - **Warning:** Irreversible. Wipes all IronJump data

---

## Access Control Management

Available only for `SERVER` and `HYBRID` roles.

**Menu Path:** `Main Menu` → `Access Control Management`

### Assignments

- **1. List All Assignments**
  - Shows all current user-to-endpoint assignments

- **2. Allow or Modify Assignments**
  - **Submenu:**
    - By User: Assign endpoints to a specific user
    - By Endpoint: Assign users to a specific endpoint

- **3. Revoke Assignments**
  - **Submenu:**
    - By User: Remove user's access to specific endpoints
    - By Endpoint: Remove all users from an endpoint

### Mass Assignments & Revocation

- **4. Allow/Revoke All Endpoints for User**
  - Quickly grant/revoke access for a user to all endpoints

- **5. Revoke ALL Assignments**
  - **Warning:** Global reset of all access control relationships

---

## Change Role Type

**Menu Path:** `Main Menu` → `Change Role Type`

- Prompts the administrator to select a new role:
  - `SERVER`
  - `ENDPOINT`
  - `HYBRID`
  - `UNASSIGNED`
- Updates the role flag stored in `/opt/IronJump/ironjump.role`

---

## System Utilities

Accessible from any menu:

- **S. SSH Monitor**
  - Displays active connections via `lsof`, `netstat`, or similar tools

- **R. Reboot Server**
  - Reboots the host after confirmation

- **Q. Quit**
  - Returns to shell

---

## Final Notes

- Logs are stored in `/var/log/ironjump.log`
- Role-specific behaviors are enforced at each menu level
- For full automation, make sure `autossh` is cloned properly:

```bash
sudo git clone --recurse-submodules https://github.com/schlpr0k/IronJump.git /opt/IronJump
```

### Offline Deployments
- For offline deployments (Not internet access during setup), the following packages must be installed on the host:
  - IronJump Server: gcc make lsof ssh openssh-client openssh-server diceware
  - Ingots (Endpoints): gcc make lsof ssh openssh-client openssh-server
  - If you can SSH into the IronJump Bastion Server from the target endpoint, use scp to clone the /opt/IronJump folder to the endpoint. The code is exactly the same.

For issues or support, please open a ticket at [GitHub Issues](https://github.com/schlpr0k/IronJump/issues).


