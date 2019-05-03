#!/bin/bash

cd /home/vagrant/setup
source params.sh

RSYSLOGDSCONF="rsyslogd.server.conf.sh"
MUNINCONF="munin.server.conf.sh"

# needs MONITORSRV to be defined
# Create 

echo "Creating Monitor Server on host $MONITORSRV"

#rsyslogd server
echo "Getting rsyslogd installed on the server $MONITORSRV "
ssh -o StrictHostKeyChecking=no root@$MONITORSRV  "bash -s" < $RSYSLOGDSCONF

echo "Getting munin installed on the server $MONITORSRV "
ssh -o StrictHostKeyChecking=no root@$MONITORSRV  "bash -s" < $MUNINCONF


