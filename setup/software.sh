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

update_aptget(){
  debug "Updating apt-get.."
  apt-get update
  say_done "Updated."

  debug "Upgrading apt-get..."
  apt-get upgrade -y
  say_done "Upgraded."

  debug "Cleaning up..."
  apt-get autoremove
  apt-get autoclean
  say_done
}

update_aptget

debug "Installing git..."
apt-get install -y git
say_done

debug "Installing libav-tools..."
apt-get install -y libav-tools
say_done
