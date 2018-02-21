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

create_tower_ssh_key(){
  debug "Creating an ssh key for the camera user..."
  su -l camera <<'EOF'
cd ~
mkdir .ssh
ssh-keygen -f ~/.ssh/id_rsa -t rsa -b 4096 -N ''
EOF
  say_done
}

create_tower_ssh_key

