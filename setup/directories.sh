#!/bin/bash

declare ROOT_DIR="$(dirname $(readlink -f $0))"
source ${ROOT_DIR}/../scripts/shared.sh

add_log_dir(){
  debug "Setting up log directories..."
  mkdir ${LOG_DIR}
  say_done
}
add_project_dir(){
  debug "Setting up project directories..."
  mkdir ${PROJECT_DIR}
  mkdir ${PROJECT_DIR}/cameras
  mkdir ${PROJECT_DIR}/config
  mkdir ${PROJECT_DIR}/scripts
  say_done
}
update_file_permissions(){
  debug "Updating permissions for watchtower group..."
  chgrp -R watchtower ${LOG_DIR}
  chgrp -R watchtower ${PROJECT_DIR}
  chmod -R g+rwx ${PROJECT_DIR}
  chmod -R g+rw ${LOG_DIR}
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
copy_scripts ${1} ${PROJECT_DIR}/scripts/
copy_configs ${2} ${PROJECT_DIR}/config/
update_file_permissions
