#!/bin/bash

declare ROOT_DIR="$(dirname $(readlink -f $0))"
source ${ROOT_DIR}/../scripts/shared.sh
source ${ROOT_DIR}/../config/remote

set_hostname(){
  debug "Setting hostname..."
  debug "Hostname: ${HOSTNAME}"
  echo "${HOSTNAME}" > /etc/hostname
  hostname "${HOSTNAME}"
  say_done
}
enable_ssh(){
  debug "Enabling ssh..."
  systemctl enable ssh
  systemctl start ssh
  say_done "Enabled."
}

restrict_ssh(){
  debug "Adding group for ssh users..."
  debug "Group: sshusers"
  groupadd -r sshusers
  say_done

  debug "Adding camera to ssh group..."
  usermod -aG sshusers camera
  say_done

  debug "Restricting ssh to group only..."
  echo "AllowGroups sshusers" >> /etc/ssh/sshd_config
  /etc/init.d/ssh restart
  say_done
}

set_hostname
enable_ssh
restrict_ssh
