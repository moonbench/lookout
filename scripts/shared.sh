#!/bin/bash

declare ROOT_DIR="$(dirname $(readlink -f $0))"
source ${ROOT_DIR}/../config/shared

# Colors
HIGHLIGHT_COLOR='\e[36m'
TITLE_COLOR='\e[4m\e[1m'
DONE_COLOR='\e[1;32m'
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
  if [[ -z "${LOG_PREFIX}" ]]; then
    return
  fi
  datestamp="$(date +\%c)"
  filedate="$(date +\%Y\%m\%d)"
  echo "[${datestamp}] ${1}" >> ${LOG_DIR}/${LOG_PREFIX}.${filedate}.log 2>&1
}
