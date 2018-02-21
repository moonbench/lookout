#!/bin/bash

HOST="localhost"
PORT="8000"
ECHO_PORT="20000"

declare ROOT_DIR="$(dirname $(readlink -f $0))"

HIGHLIGHT_COLOR='\e[36m'
DONE_COLOR='\e[1;32m'
NO_COLOR='\e[0m'

debug(){
  echo -e "${HIGHLIGHT_COLOR}${1}${NO_COLOR}"
}
say_done(){
  echo -e "${DONE_COLOR}Done.${NO_COLOR}\\n"
}

open_reverse_tunnel(){
  debug "Creating reverse tunnel..."
  debug "Remote: towers@${HOST}"
  debug "Remote reverse port: ${PORT}"
  debug "Keep-alive echo port: ${ECHO_PORT}"

  autossh -M ${ECHO_PORT} -f -N -R ${PORT}:localhost:22 towers@${HOST}
  say_done
}

source /var/watchtower/config/remote

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
