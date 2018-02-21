#!/bin/bash

HIGHLIGHT_COLOR='\e[36m'
TITLE_COLOR='\e[4m\e[1m'
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

add_log_dir(){
  debug "Setting up log directories..."
  mkdir /var/log/watchtower
  say_done
}
add_project_dir(){
  debug "Setting up project directories..."
  mkdir /var/watchtower
  mkdir /var/watchtower/cameras
  mkdir /var/watchtower/config
  mkdir /var/watchtower/scripts
  say_done
}
update_file_permissions(){
  debug "Updating permissions for watchtower group..."
  chgrp -R watchtower /var/log/watchtower
  chgrp -R watchtower /var/watchtower
  chmod -R g+rwx /var/watchtower
  chmod -R g+rw /var/log/watchtower
  say_done
}

copy_scripts(){
  debug "Copying in scripts..."
  debug "Source: ${1}"
  debug "Destination: ${2}"
  cp -r ${1} ${2}
  say_done "Scripts copied."
}

copy_configs(){
  debug "Copying in config files..."
  debug "Source: ${1}"
  debug "Destination: ${2}"
  cp -r ${1} ${2}
  say_done "Config copied."
}

add_log_dir
add_project_dir
copy_scripts ${1} /var/watchtower/scripts/
copy_configs ${2} /var/watchtower/config/
update_file_permissions
