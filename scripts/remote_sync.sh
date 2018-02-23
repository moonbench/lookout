#!/bin/bash

declare ROOT_DIR="$(dirname $(readlink -f $0))"

LOG_PREFIX='network'
source ${ROOT_DIR}/shared.sh

sync_files(){
  source /var/watchtower/config/remote
  name="$(hostname)"
  debug "Running rsync..."

  filedate="$(date +\%Y\%m\%d)"
  rsync -hvzae 'ssh -p 22' --progress /var/watchtower/cameras towers@${HOST}:/var/watchtower/towers/${name} >> /var/log/watchtower/${LOG_PREFIX}.${filedate}.log 2>&1
  say_done
}

title "Syncing to server..."
sync_files
success "Sync finished."
