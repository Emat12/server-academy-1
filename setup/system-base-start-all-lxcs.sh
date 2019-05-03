#!/usr/bin/env bash
#
# eSHIFT / HISP Geneva - For Dar es Salaam UiO Systems Admin Academy
# "Steven Uggowitzer" <whotopia@gmail.com>
#
# This file can be run repeatedly with no problems
#

cd /home/vagrant/setup

for lxc in `cat lxcs.txt`; do
  HOSTNAME="$lxc"
  sudo lxc start $lxc > /dev/null 2>&1
done

