#!/bin/bash

# Defaults
FRAMERATE=16
QUALITY=2
OUTPUT="output.webm"

make_timelapse(){
  avconv -framerate ${FRAMERATE} -f image2 -i %06d.jpg -q ${QUALITY} ${OUTPUT}
}

make_timelapse
