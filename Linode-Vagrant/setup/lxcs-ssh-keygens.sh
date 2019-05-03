#!/usr/bin/env bash
#
# eSHIFT / HISP Geneva - For Dar es Salaam UiO Systems Admin Academy
# "Steven Uggowitzer" <whotopia@gmail.com>
#
# This file can be run repeatedly with no problems
#
# Writes new ssh keys for all lxc containers in container file
# copies authorized_keys to each container root user
#

cd /home/vagrant/setup

#Make sure that root ssh key exisits
sudo  ./system-base-root-ssh.sh
sudo ./system-base-vagrant-ssh.sh
sudo  ./lxcs-ssh-push-keys.sh


# just in case clean out old local keys
sudo rm -f /root/.ssh/known_hosts*


