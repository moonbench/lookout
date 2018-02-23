#!/bin/bash
declare ROOT_DIR="$(dirname $(readlink -f $0))"
source ${ROOT_DIR}/scripts/shared.sh

NUM_CAMERAS=$((ls -l /dev/video*) | wc -l)

for (( i=0; i<NUM_CAMERAS; i++ )); do
  ${PROJECT_DIR}/scripts/take_photo.sh -c "$i"
done

