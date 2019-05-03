#!/usr/bin/env bash
#
# eSHIFT / HISP Geneva - For Dar es Salaam UiO Systems Admin Academy
# "Steven Uggowitzer" <whotopia@gmail.com>
#
# This file can be run repeatedly with no problems
#
# Updates all lxcs and adds essential packages common to all of them
# Note needs to have ssh access before running!!!!!!

BASEFIXES='lxc-base-ubuntu.sh'
cd /home/vagrant/setup

for lxc in `cat lxcs.txt`; do
  HOSTNAME="$lxc"
  echo "Updating Ubuntu and installing shared / core essential packages for lxc $lxc hostname $HOSTNAME"
  ssh -o StrictHostKeyChecking=no root@$HOSTNAME "bash -s" < $BASEFIXES     
done

