#!/bin/bash

HOSTNAME="watchtower1"

declare ROOT_DIR="$(dirname $(readlink -f $0))"

HIGHLIGHT_COLOR='\e[36m'
TITLE_COLOR='\e[4m\e[1m'
DONE_COLOR='\e[1;32m'
NO_COLOR='\e[0m'

debug(){
  echo -e "${HIGHLIGHT_COLOR}${1}${NO_COLOR}"
}
title(){
  echo -e "${TITLE_COLOR}${1}${NO_COLOR}"
}
success(){
  echo -e "${DONE_COLOR}${TITLE_COLOR}${1}${NO_COLOR}"
}
say_done(){
  local donemsg="Done."
  if [[ ! -z "${1}" ]]; then
    donemsg=$1
  fi
  echo -e "${DONE_COLOR}$donemsg${NO_COLOR}"
}

echo "Setting up the watchtower..."

setup_directories(){
  debug "Setting up project directories..."
  mkdir /var/log/watchtower
  mkdir /var/watchtower
  mkdir /var/watchtower/cameras
  mkdir /var/watchtower/scripts
  say_done

  copy_scripts

  debug "Updating groups..."
  chgrp -R watchtower /var/log/watchtower
  chgrp -R watchtower /var/watchtower
  chmod -R g+rwx /var/watchtower
  chmod -R g+rw /var/log/watchtower
  say_done
}
copy_scripts(){
  debug "Copying in scripts..."
  cp -r ${ROOT_DIR}/scripts/. /var/watchtower/scripts/
  say_done "Scripts copied."
}

setup_users(){
  debug "Setting up users..."
  remove_pi_user

  debug "Creating watchtower users..."
  useradd -m camera
  useradd -m reader
  say_done

  debug "Adding watchtower group..."
  groupadd -r watchtower
  usermod -aG watchtower reader
  usermod -aG watchtower camera
  say_done

  say_done "Users ready."
}
remove_pi_user(){
  debug "Removing pi user..."
  userdel -f pi
  say_done
}

setup_network(){
  debug "Setting up networking..."
  set_hostname
  enable_ssh
  say_done "Network configured."
}
set_hostname(){
  debug "Setting hostname..."
  echo "${HOSTNAME}" > /etc/hostname
  hostname "${HOSTNAME}"
  say_done
}
enable_ssh(){
  debug "Enabling ssh..."
  systemctl enable ssh
  systemctl start ssh
  say_done

  debug "Adding group for ssh users..."
  groupadd -r sshusers
  usermod -aG sshusers reader
  echo "AllowGroups sshusers" >> /etc/ssh/sshd_config
  /etc/init.d/ssh restart
  say_done
}

install_software(){
  update_aptget
  install_libav
}
update_aptget(){
  debug "Updating apt-get.."
  apt-get update
  apt-get upgrade -y
  apt-get autoremove
  apt-get autoclean
  debug "Updated."
}
install_libav(){
  apt-get install -y libav-tools
}


title "New tower setup"
setup_users
setup_directories
setup_network
install_software
success "Tower ready!"

