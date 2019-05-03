#!/bin/bash

# This will make whatever server it is run on a complete listening rsyslogd host
RSYSLOGCONF='/etc/rsyslog.conf'

if [[ ! -f "$RSYSLOGCONF.orig" ]]; then
   # likely a 1st time run
   echo " Installing rsyslogd"
   sudo  DEBIAN_FRONTEND=noninteractive apt-get -y update
   sudo  DEBIAN_FRONTEND=noninteractive apt-get -y install rsyslog
   sudo  DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
   # save a copy of the original distro conf file
   echo " Copying $RSYSLOGCONF to safe place"
   cp -f $RSYSLOGCONF "$RSYSLOGCONF.orig"
else
	# reset and try again
   cp -f "$RSYSLOGCONF.orig" $RSYSLOGCONF

cat >> $RSYSLOGCONF <<- "EOF"
#
# Adds central syslog capability and sends all logs to the 'monitor' syslog host
#
$PreserveFQDN on
# The above line will enable sending of logs over UDP, for tcp use @@ instead of a single @
*.* @monitor:514
# *.* @@ip-address-of-rsysog-server:514
# Also add the following for when rsyslog server will be down:
$ActionQueueFileName queue
$ActionQueueMaxDiskSpace 1g
$ActionQueueSaveOnShutdown on
$ActionQueueType LinkedList
$ActionResumeRetryCount -1
EOF

sudo systemctl enable rsyslog
sudo systemctl restart rsyslog
fi

