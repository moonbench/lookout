#!/bin/bash

declare ROOT_DIR="$(dirname $(readlink -f $0))"

LOG_PREFIX='cron'
source ${ROOT_DIR}/shared.sh

reset_crontab(){
  debug "Resetting crontab..."
  echo "" | crontab -
  say_done
}

set_timelapse(){
  source ${PROJECT_DIR}/config/timelapse
  if [[ -z "${TIMELAPSE}" ]]; then
    return
  fi

  debug "Setting timelapse..."
  (crontab -l; echo "${FREQUENCY} (cd ${PROJECT_DIR}/scripts && ./take_all_photos.sh && ./remote_sync.sh)") | crontab -
  say_done
}

set_connect(){
  debug "Setting crontab to auto connect to server on reboot..."
  (crontab -l; echo "@reboot ${PROJECT_DIR}/scripts/connect.sh") | crontab -
  say_done
}

reset_crontab
set_timelapse
set_connect

