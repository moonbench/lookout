#!/bin/bash

declare ROOT_DIR="$(dirname $(readlink -f $0))"
source ${ROOT_DIR}/../scripts/shared.sh

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

