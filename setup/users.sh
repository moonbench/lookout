#!/bin/bash

declare ROOT_DIR="$(dirname $(readlink -f $0))"
source ${ROOT_DIR}/../scripts/shared.sh

add_watchtower_users(){
  debug "Creating watchtower users..."
  useradd -m camera -s /bin/bash
  groupadd -r watchtower
  usermod -aG video camera
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
