#!/bin/bash

declare ROOT_DIR="$(dirname $(readlink -f $0))"

# Defaults
LENGTH=20
QUALITY=15
CAMERA=0
RESOLUTION="1280x720"

source ${ROOT_DIR}/shared.sh

# Camera stuff
record_video(){
  camera_source="/dev/video${CAMERA}"

  debug "Camera: ${camera_source}"
  debug "Length: ${LENGTH}"
  debug "Quality: ${QUALITY}"
  debug "Resolution: ${RESOLUTION}"

  filedate="$(date +\%Y\%m\%d)"
  outputdir="${PROJECT_DIR}/cameras/${CAMERA}" && mkdir -p "${outputdir}"
  outputdir="${outputdir}/videos" && mkdir -p "${outputdir}"
  outputdir="${outputdir}/$(date +\%Y)" && mkdir -p "${outputdir}"
  outputdir="${outputdir}/$(date +\%m\%d)" && mkdir -p "${outputdir}"
  output="${outputdir}/$(date +\%H\%M\%S).flv"
  debug "Output file: ${output}"

  debug "Capturing video..."
  avconv -f video4linux2 -s ${RESOLUTION} -i ${camera_source} -t ${LENGTH} -q ${QUALITY} ${output} >> ${LOG_DIR}/${LOG_PREFIX}.${filedate}.log 2>&1
  say_done
}

while getopts ':c:l:q:r:' opt; do
  case "${opt}" in
    c) CAMERA="$OPTARG" ;;
    l) LENGTH="$OPTARG" ;;
    q) QUALITY="$OPTARG" ;;
    r) RESOLUTION="$OPTARG" ;;
    *) echo "Unknown option: -${OPTARG}" >&2
       exit 1 ;;
  esac
done

echo "${CAMERA}"
if [[ -z "${CAMERA}" ]]; then
  error "No camera specified"
  exit 1
fi

LOG_PREFIX="camera_${CAMERA}"

title "Recording video..."
record_video
success "Recorded"
