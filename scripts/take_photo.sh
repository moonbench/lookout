#!/bin/bash

declare ROOT_DIR="$(dirname $(readlink -f $0))"

source ${ROOT_DIR}/shared.sh

# Camera stuff
take_picture(){
  camera_source="/dev/video${CAMERA}"
  debug "Camera: ${camera_source}"

  resolution=""
  if [[ ! -z "${RESOLUTION}" ]]; then
    debug "Resolution: ${RESOLUTION}"
    resolution="-s ${RESOLUTION}"
  fi

  quality=""
  if [[ ! -z "${QUALITY}" ]]; then
    debug "Quality: ${QUALITY}"
    quality="-q ${QUALITY}"
  fi

  delay=""
  if [[ ! -z "${DELAY}" ]]; then
    debug "Delay: ${DELAY}"
    delay="-ss ${DELAY}"
  fi


  filedate="$(date +\%Y\%m\%d)"
  outputdir="${PROJECT_DIR}/cameras/${CAMERA}" && mkdir -p "${outputdir}"
  outputdir="${outputdir}/images" && mkdir -p "${outputdir}"
  outputdir="${outputdir}/$(date +\%Y)" && mkdir -p "${outputdir}"
  outputdir="${outputdir}/$(date +\%m-\%d)" && mkdir -p "${outputdir}"
  output="${outputdir}/$(date +\%H:\%M:\%S).jpg"
  debug "Output file: ${output}"

  debug "Capturing image..."
  avconv -f video4linux2 -i ${camera_source} ${resolution} ${quality} ${delay} -vframes 1 ${output} >> ${LOG_DIR}/${LOG_PREFIX}.${filedate}.log 2>&1
  say_done
}

# Run the script
while getopts ':c:q:r:d:' opt; do
  case "${opt}" in
    c) CAMERA="$OPTARG" ;;
    q) QUALITY="$OPTARG" ;;
    r) RESOLUTION="$OPTARG" ;;
    d) DELAY="$OPTARG" ;;
    *) echo "Unknown option: -${OPTARG}" >&2
       exit ;;
  esac
done


if [[ -z "${CAMERA}" ]]; then
  error "No camera specified"
  exit 1
fi

LOG_PREFIX="camera_${CAMERA}"

title "Taking photo..."
take_picture
success "Picture taken."
