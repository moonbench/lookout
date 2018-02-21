#!/bin/bash

HOST="localhost"
declare ROOT_DIR="$(dirname $(readlink -f $0))"

HIGHLIGHT_COLOR='\e[36m'
TITLE_COLOR='\e[4m\e[1m'
DONE_COLOR='\e[1;32m'
NO_COLOR='\e[0m'

debug(){
  echo -e "${HIGHLIGHT_COLOR}${1}${NO_COLOR}"
}
title(){
  echo -e "${TITLE_COLOR}${1}${NO_COLOR}\\n"
}
success(){
  echo -e "${DONE_COLOR}${TITLE_COLOR}${1}${NO_COLOR}"
}
say_done(){
  local donemsg="Done."
  if [[ ! -z "${1}" ]]; then
    donemsg=$1
  fi
  echo -e "${DONE_COLOR}$donemsg${NO_COLOR}\\n"
}

copy_keys_to_server(){
  debug "Copying public keys to the server..."
  su -l camera <<EOF
ssh-copy-id towers@${HOST}
EOF
  say_done
}

while getopts ":h:" opt; do
  case "${opt}" in
    h) HOST="$OPTARG" ;;
    *) echo "Unknown option: -${OPTARG}">&2
       exit 1 ;;
  esac
done

title "Watchtower remote setup tool"
copy_keys_to_server
success "Remote authentication ready."
