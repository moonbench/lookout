#!/bin/bash

rename_images(){
  a=1
  for i in *.jpg; do
    new=$(printf "%06d.jpg" "$a")
    mv -i -- "$i" "$new"
    let a=a+1
  done
}

rename_images
