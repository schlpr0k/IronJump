#!/bin/bash
# Password rotation for IronJump Downstream Bastions, Endpoints, and SSH Users
IRONJUMP_SSH_GROUP="ironjump_users"
IRONJUMP_SRV_GROUP="ironjump_servers"
IRONJUMP_END_GROUP="ironjump_enpoints"
PASSWORD_LENGTH="64"

### Password Length and Rotation
### ============================
## NOTE: IronJump Servers (Upstream or Downstream): devices [endpoints], servers, and users account passwords are not used. Admins should
#        use Password/Passphrase-protected SSH keys for authentication. This is due to the /bin/false shell. IronJump accounts are never
#        used for management of the bastion servers. Furthermore, the endpoints that connect to an IronJump bastion are treated similarly.
#        This is to prevent elevating privileges or connecting to other hosts in the IronJump ecosystem. Endpoints and Downstream IronJump
#        bastions are connected without password protected keys. Therefore, it is vital to ensure that someone cannot guess a
#        password for the account in use. By rotating the passwords every 8 hours, the use of passwords is efectively disabled.

## NOTE: It is not recommended to change these settings unless there is a good reason. There is a passcode generator function in the
#        IronJump menu under Endpoint Management to create or reset a password of a new or existing user directly on the host.

## NOTE: To change the rotation period. Directly edit the cron job from an elevated account.

### -----------------------------

ironjump_change_password() {
    account=$1
    NEW_PASSWORD=$(tr -dc 'A-Za-z0-9~!@#$%^&*()_+-=[]{};:<>,.?/`'"'" < /dev/urandom |head -c$PASSWORD_LENGTH)
    echo "$account:$NEW_PASSWORD" | chpasswd
    unset NEW_PASSWORD
}

for user in $(getent group $IRONJUMP_SSH_GROUP |awk -F: '{print $4}' | tr ',' ' '); do ironjump_change_password $user; done
for server in $(getent group $IRONJUMP_SRV_GROUP |awk -F: '{print $4}' | tr ',' ' '); do ironjump_change_password $server; done
for endpoint in $(getent group $IRONJUMP_END_GROUP |awk -F: '{print $4}' | tr ',' ' '); do ironjump_change_password $endpoint; done

