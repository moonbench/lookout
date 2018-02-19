#!/bin/bash

NUM_CAMERAS=$((ls -l /dev/video*) | wc -l)

for (( i=0; i<NUM_CAMERAS; i++ )); do
  /var/watchtower/scripts/take_photo.sh -c "$i"
done

