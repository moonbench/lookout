#!/bin/bash

declare ROOT_DIR="$(dirname $(readlink -f $0))"
source ${ROOT_DIR}/../scripts/shared.sh

update_aptget(){
  debug "Updating apt-get.."
  apt-get update
  say_done "Updated."

  debug "Upgrading apt-get..."
  apt-get upgrade -y
  say_done "Upgraded."

  debug "Cleaning up..."
  apt-get autoremove
  apt-get autoclean
  say_done
}

update_aptget

debug "Installing git, libav-tools, rsync, and autossh..."
apt-get install -y git libav-tools rsync autossh
say_done
