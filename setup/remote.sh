#!/bin/bash

declare ROOT_DIR="$(dirname $(readlink -f $0))"
source ${ROOT_DIR}/../scripts/shared.sh

copy_keys_to_server(){
  debug "Copying public keys to the server..."
  su -l camera <<EOF
ssh-copy-id towers@${HOST}
${PROJECT_DIR}/scripts/connect.sh -h ${HOST}
EOF
  say_done
}

source ${PROJECT_DIR}/config/remote

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
