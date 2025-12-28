#!/bin/bash

function sshPublisher_publish {
  local SSH_CONFIG_DIR="$1"
  local SSH_SOURCE_DIR="$2"
  local SSH_TARGET_ID="$3"
  . "$SSH_CONFIG_DIR/ssh-config.sh"
  sshConfig_set "$SSH_CONFIG_DIR" "$SSH_TARGET_ID"
  local KEY="yes"
  #read -p "$(tput bold)$(tput setaf 5)Make sure Air Condition is off, then type 'yes'... $(tput sgr0)" KEY
  if [ "$KEY" != "yes" ]; then
    exit 1
  fi
  SECONDS=0
  rsync -e "ssh -i ${SSH_KEYFILE}" -rtP "${SSH_SOURCE_DIR}/" "${SSH_USER}@${SSH_HOST}:${SSH_WEBDIR}" --delete --exclude=".*"
  echo "published in $SECONDS sec"
}
