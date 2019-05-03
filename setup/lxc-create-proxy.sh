#!/bin/bash

cd /home/vagrant/setup
source params.sh

# needs PROXYSRV to be defined
# Create 
SRV=$PROXYSRV
HOSTN=$(</etc/hostname)

echo "Creating Apache-Based Proxy Server on host $SRV"
echo "Assuming Internet Hostname $HOSTN "

#rsyslogd server
PHASE1="proxy.server-base.conf.sh"
PHASE2="proxy.server-apache2.conf.sh"
PHASE3="proxy.server-certbot.conf.sh"

PHASE="PROXYPHASE1"
if [[ ! -f "$PHASE" ]]; then
  ssh -o StrictHostKeyChecking=no root@$SRV  "bash -s" < $PHASE1
  touch PROXYPHASE1
else  
   echo "$0 $PHASE Done."
fi

PHASE="PROXYPHASE2"
if [[ ! -f "$PHASE" ]]; then
  #Copy the template files for the html dir over  (rsync would be better)
  scp -o StrictHostKeyChecking=no -r $BASEDIR/apache2 root@proxy:/var/www/
  ssh -o StrictHostKeyChecking=no root@$SRV  "bash -s" < $PHASE2 "$HOSTN"
  touch $PHASE
else
   echo "$0 PROXYPHASE2 Done."
fi

PHASE="PROXYPHASE3"
if [[ ! -f "$PHASE" ]]; then
  ssh -o StrictHostKeyChecking=no root@$SRV  "bash -s" < $PHASE3 "$HOSTN"
  lxc file push dhis2.conf $SRV/etc/apache2/
  touch $PHASE
else
   echo "$0 PROXYPHASE3 Done."
fi


