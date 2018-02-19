#!/bin/bash

declare ROOT_DIR="$(dirname $(readlink -f $0))"
declare TMP_DIR="/tmp/timelapse_$(date +\%Y\%m\%d\%H\%M\%S)"
OUTPUT_FILE="output.webm"

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
  echo "[${datestamp}] ${1}" >> /var/log/watchtower/timelapse.${filedate}.log 2>&1
}

copy_to_tmp(){
  debug "Copying files to /tmp..."
  debug "Output directory: ${TMP_DIR}"
  mkdir -p ${TMP_DIR}
  if [[ "${#@}" -eq 1 && -d "${1}" ]]; then
    copy_directory_to_tmp $1
  else
    copy_files_to_tmp
  fi
  say_done "Files copied to /tmp"
}
copy_files_to_tmp(){
  debug "Using: List of files"
}
copy_directory_to_tmp(){
  debug "Using: Directory"
  cp -r ${1}/. ${TMP_DIR}
}
rename_files(){
  debug "Renaming files..."
  echo "${ROOT_DIR}"
  cp ${ROOT_DIR}/rename_images.sh ${TMP_DIR}
  (cd ${TMP_DIR} && ./rename_images.sh)
  say_done
}
make_timelapse(){
  debug "Creating timelapse..."
  (cd ${TMP_DIR} && avconv -framerate 16 -f image2 -i %06d.jpg -q 15 ${OUTPUT_FILE})
  say_done
}

create_timelapse(){
  title "Making a timelapse"
  copy_to_tmp $@
  rename_files
  make_timelapse
  success "Timelapse created!"
}

if [[ $# -eq 0 ]]; then
  error "No input provided"
  exit 1
fi

while getopts "o" opt; do
  case "$opt" in
    o) OUTPUT=$OPTARG
       ;;
  esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

echo "${#@}"
echo "$1"
create_timelapse $@
