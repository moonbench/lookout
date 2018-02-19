#!/bin/bash

HOSTNAME="watchtower1"

declare ROOT_DIR="$(dirname $(readlink -f $0))"

HIGHLIGHT_COLOR='\e[36m'
TITLE_COLOR='\e[4m\e[1m'
DONE_COLOR='\e[1;32m'
NO_COLOR='\e[0m'

debug(){
  echo -e "=> ${HIGHLIGHT_COLOR}${1}${NO_COLOR}"
}
title(){
  echo -e "== ${TITLE_COLOR}${1}${NO_COLOR} ==\\n"
}
success(){
  echo -e "== ${DONE_COLOR}${TITLE_COLOR}${1}${NO_COLOR} =="
}
say_done(){
  local donemsg="Done."
  if [[ ! -z "${1}" ]]; then
    donemsg=$1
  fi
  echo -e "=> ${DONE_COLOR}$donemsg${NO_COLOR}\\n"
}

title "Fresh watchtower setup tool"

debug "Setting up users..."
${ROOT_DIR}/setup/users.sh
say_done

debug "Setting up directories..."
${ROOT_DIR}/setup/directories.sh ${ROOT_DIR}/scripts/.
say_done

debug "Setting up networking..."
${ROOT_DIR}/setup/network.sh ${HOSTNAME}
say_done

debug "Setting up software..."
${ROOT_DIR}/setup/software.sh
say_done

success "Watchtower setup finished."
debug "Now use passwd to update the authentication for reader and camera."
debug "Next use su to become camera and run /var/watchtower/scripts/set_crontab.sh"
