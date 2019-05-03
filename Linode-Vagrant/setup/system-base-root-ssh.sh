#!/bin/bash
#
# If root's key doesn't exist, then create it.
#
pubkey="/root/.ssh/id_rsa.pub"
privkey="/root/.ssh/id_rsa"

if [[ ! -f "$pubkey" ]]; then
  echo "Generating root ssh key"
  yes | sudo ssh-keygen -t rsa -N "" -f $privkey
fi

