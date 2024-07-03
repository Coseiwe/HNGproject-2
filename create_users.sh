#!/bin/bash

# Step 1: Define File Locations
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.txt"

# Step 2: Create Directories
mkdir -p /var/log
mkdir -p /var/secure

# Step 3: Set File Permissions
touch $PASSWORD_FILE
chmod 600 $PASSWORD_FILE
touch $LOG_FILE
chmod 644 $LOG_FILE

# Step 4: Define Logging Function
log_action() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> $LOG_FILE
}

# Step 5: Argument Checking
if [ $# -ne 1 ]; then
  log_action "Usage: $0 <user-list-file>. Exiting."
  exit 1
fi

USER_LIST_FILE=$1

if [ ! -f $USER_LIST_FILE ]; then
  log_action "File $USER_LIST_FILE does not exist! Exiting."
  exit 1
fi

# Step 6: Reading and Processing User List
while IFS=';' read -r username groups; do
  username=$(echo $username | xargs)
  groups=$(echo $groups | xargs)

  # Step 7: User Existence Checking and Creation
  if id -u $username >/dev/null 2>&1; then
    log_action "User $username already exists. Skipping."
    continue
  fi

  useradd -m $username
  if [ $? -eq 0 ]; then
    log_action "User $username created successfully."
  else
    log_action "Failed to create user $username."
    continue
  fi

  # Step 8: Group Handling
  IFS=',' read -ra USER_GROUPS <<< "$groups"
  for group in "${USER_GROUPS[@]}"; do
    group=$(echo $group | xargs)
    if ! getent group $group >/dev/null; then
      groupadd $group
      if [ $? -eq 0 ]; then
        log_action "Group $group created successfully."
      else
        log_action "Failed to create group $group."
        continue
      fi
    fi
    usermod -aG $group $username
    log_action "User $username added to group $group."
  done

  # Step 9: Home Directory Setup
  chmod 755 /home/$username
  chown $username:$username /home/$username
  log_action "Home directory permissions set for user $username."

  # Step 10: Password Generation and Storage
  password=$(date +%s | sha256sum | base64 | head -c 12 ; echo)
  echo "$username,$password" >> $PASSWORD_FILE
  log_action "Password for user $username set successfully."

done < $USER_LIST_FILE

# Step 11: Script Completion and Finalization
log_action "Script execution completed."
