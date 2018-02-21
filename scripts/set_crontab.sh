#!/bin/bash

debug(){
  echo -e "${1}"
}
say_done(){
  debug "Done."
}

reset_crontab(){
  debug "Resetting crontab..."
  echo "" | crontab -
  say_done
}

set_timelapse(){
  source /var/watchtower/config/timelapse
  if [[ -z "${TIMELAPSE}" ]]; then
    return
  fi

  debug "Setting timelapse..."
  (crontab -l; echo "*/15 * * * * (cd /var/watchtower/scripts && ./take_all_photos.sh && ./remote_sync.sh)") | crontab -
  say_done
}

set_connect(){
  debug "Setting crontab to auto connect to server on reboot..."
  (crontab -l; echo "@reboot /var/watchtower/scripts/connect.sh") | crontab - 
  say_done
}

reset_crontab
set_timelapse
set_connect

