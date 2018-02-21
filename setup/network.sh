#!/bin/bash

HIGHLIGHT_COLOR='\e[36m'
DONE_COLOR='\e[1;32m'
NO_COLOR='\e[0m'

debug(){
  echo -e "${HIGHLIGHT_COLOR}${1}${NO_COLOR}"
}
say_done(){
  local donemsg="Done."
  if [[ ! -z "${1}" ]]; then
    donemsg=$1
  fi
  echo -e "${DONE_COLOR}$donemsg${NO_COLOR}"
}

set_hostname(){
  debug "Setting hostname..."
  debug "Hostname: ${1}"
  echo "${1}" > /etc/hostname
  hostname "${1}"
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

set_hostname ${1}
enable_ssh
restrict_ssh
