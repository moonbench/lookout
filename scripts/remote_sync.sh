#!/bin/bash

declare ROOT_DIR="$(dirname $(readlink -f $0))"

LOG_PREFIX='network'
source ${ROOT_DIR}/shared.sh

sync_files(){
  source ${PROJECT_DIR}/config/remote
  name="$(hostname)"
  filedate="$(date +\%Y\%m\%d)"

  debug "Local sync source: ${PROJECT_DIR}/cameras"
  debug "Remote sync destination: ${PROJECT_DIR}/towers/${name}"

  debug "Running rsync..."
  rsync -hvzae 'ssh -p 22' --progress ${PROJECT_DIR}/cameras towers@${HOST}:/var/watchtower/towers/${name} >> ${LOG_DIR}/${LOG_PREFIX}.${filedate}.log 2>&1
  say_done
}

title "Syncing to server..."
sync_files
success "Sync finished."
