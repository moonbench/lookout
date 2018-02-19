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

add_watchtower_users(){
  debug "Creating watchtower users..."
  useradd -m camera
  useradd -m reader
  say_done
}
add_watchtower_group(){
  debug "Adding watchtower group..."
  groupadd -r watchtower
  usermod -aG watchtower reader
  usermod -aG watchtower camera
  say_done
}
remove_pi_user(){
  debug "Removing pi user..."
  userdel -f pi
  say_done
}

remove_pi_user
add_watchtower_users
add_watchtower_group
