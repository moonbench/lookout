#!/bin/bash

declare ROOT_DIR="$(dirname $(readlink -f $0))"

LOG_PREFIX='network'
source ${ROOT_DIR}/shared.sh

open_reverse_tunnel(){
  debug "Creating reverse tunnel..."
  debug "Remote: towers@${HOST}"
  debug "Remote reverse port: ${PORT}"
  debug "Keep-alive echo port: ${ECHO_PORT}"

  autossh -M ${ECHO_PORT} -f -N -R ${PORT}:localhost:22 towers@${HOST}
  say_done
}

source ${PROJECT_DIR}/config/remote

while getopts ":h:p:" opt; do
  case "${opt}" in
    h) HOST="$OPTARG" ;;
    p) PORT="$OPTART" ;;
    e) ECHO_PORT="$OPTARG" ;;
    *) echo "Unknown option: -${OPTARG}">&2
       exit 1 ;;
  esac
done

open_reverse_tunnel
