#!/bin/bash

# Colors
HIGHLIGHT_COLOR='\e[36m'
TITLE_COLOR='\e[4m\e[1m'
DONE_COLOR='\e[1;32m'
ERROR_COLOR='\e[41m'
NO_COLOR='\e[0m'

# Output functions
debug(){
  log "${1}"
  echo -e "${HIGHLIGHT_COLOR}${1}${NO_COLOR}"
}
title(){
  log "== ${1} =="
  echo -e "${TITLE_COLOR}${1}${NO_COLOR}"
}
success(){
  log "== ${1} =="
  log ""
  echo -e "${DONE_COLOR}${TITLE_COLOR}${1}${NO_COLOR}"
}
error(){
  local errormsg="Error: ${1}"
  log "${errormsg}"
  echo -e "${ERROR_COLOR}${errormsg}${NO_COLOR}"
}
say_done(){
  local donemsg="Done."
  if [[ ! -z "${1}" ]]; then
    donemsg="${1}"
  fi
  log "${donemsg}"
  echo -e "${DONE_COLOR}$donemsg${NO_COLOR}"
}

# Logging
log(){
  datestamp="$(date +\%c)"
  filedate="$(date +\%Y\%m\%d)"
  if [[ -z "${CAMERA}" ]]; then
    echo "[${datestamp}] ${1}" >> /var/log/watchtower/null_camera.log 2>&1
  else
    echo "[${datestamp}] ${1}" >> /var/log/watchtower/camera_${CAMERA}.${filedate}.log 2>&1
  fi
}

# Camera stuff
take_picture(){
  title "Running photo script for camera \"${CAMERA}\""

  filedate="$(date +\%Y\%m\%d)"
  outputdir="/var/watchtower/cameras/${CAMERA}" && mkdir -p "${outputdir}"
  outputdir="${outputdir}/images" && mkdir -p "${outputdir}"
  outputdir="${outputdir}/$(date +\%Y)" && mkdir -p "${outputdir}"
  outputdir="${outputdir}/$(date +\%m\%d)" && mkdir -p "${outputdir}"
  output="${outputdir}/$(date +\%H\%M\%S).jpg"
  debug "Output file: ${output}"

  debug "Taking picture..."
  avconv -f video4linux2 -i /dev/video${CAMERA} -vframes 1 -ss 1 ${output} >> /var/log/watchtower/camera_${CAMERA}.${filedate}.log 2>&1
  say_done

  success "Photo script finished."
}

# Run the script
if [[ -z "${1}" ]]; then
  error "No camera specified"
  exit 1
fi

declare CAMERA="${1}"
take_picture
