#!/bin/bash

declare ROOT_DIR="$(dirname $(readlink -f $0))"
source ${ROOT_DIR}/scripts/shared.sh

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

while getopts ":H:h:" opt; do
  case "${opt}" in
    H) HOSTNAME="$OPTARG" ;;
    h) HOST="$OPTARG" ;;
    *) echo "Unknown option: -${OPTARG}">&2
       exit 1 ;;
  esac
done

title "Watchtower setup tool"

debug "Setting up users..."
${ROOT_DIR}/setup/users.sh
say_done

debug "Setting up directories..."
${ROOT_DIR}/setup/directories.sh ${ROOT_DIR}/scripts/. ${ROOT_DIR}/config/.
say_done

debug "Setting up networking..."
${ROOT_DIR}/setup/network.sh
say_done

debug "Setting up software..."
${ROOT_DIR}/setup/software.sh
say_done

debug "Setting up SSH keys..."
${ROOT_DIR}/setup/ssh.sh
say_done

debug "Starting cron jobs for camera user..."
su camera <<EOF
${PROJECT_DIR}/scripts/set_crontab.sh
EOF
say_done

success "Watchtower setup finished."
echo ""
debug "Suggested next steps:"
debug "\\t- Run: $ passwd camera"
debug "\\t- Run: $ setup/remote.js"
