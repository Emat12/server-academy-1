#!/bin/bash
#
# If root's key doesn't exist, then create it.
#
pubkey="/home/vagrant/.ssh/id_rsa.pub"
privkey="/home/vagrant/.ssh/id_rsa"


if [[ ! -f "$pubkey" ]]; then
  echo "Generating root ssh key"
  sudo mkdir -p /home/vagrant/.ssh
  sudo ssh-keygen -t rsa -N "" -f $privkey
  sudo chmod 700 /home/vagrant/.ssh
  sudo chmod 600 /home/vagrant/.ssh/authorized_keys
  sudo chown -R vagrant /home/vagrant/.ssh
fi

