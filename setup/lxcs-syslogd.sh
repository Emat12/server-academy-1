#!/usr/bin/env bash
#
# eSHIFT / HISP Geneva - For Dar es Salaam UiO Systems Admin Academy
# "Steven Uggowitzer" <whotopia@gmail.com>
#
# This file can be run repeatedly with no problems
#
#

cd /home/vagrant/setup

for lxc in `cat lxcs.txt`; do
   if [ $lxc == "monitor" ]; then
          echo "Skipping the monitor server"
   else
        echo "Making lxc container $lxc report syslog to monitor"
     
        #rsyslogd client
       RSYSLOGDSCONF="rsyslogd.client.conf.sh"
       ssh -o StrictHostKeyChecking=no root@$lxc  "bash -s" < $RSYSLOGDSCONF   
   fi
	
done


