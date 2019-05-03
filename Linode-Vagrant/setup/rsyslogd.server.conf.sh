#!/bin/bash

# This will make whatever server it is run on a complete listening rsyslogd host
RSYSLOGCONF='/etc/rsyslog.conf'

if [[ ! -f "$RSYSLOGCONF.orig" ]]; then
   # likely a 1st time run
   sudo DEBIAN_FRONTEND=noninteractive apt-get -y update
   sudo DEBIAN_FRONTEND=noninteractive apt-get -y install rsyslog
   sudo DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
   # save a copy of the original distro conf file
   cp -f $RSYSLOGCONF "$RSYSLOGCONF.orig"
else
	# reset and try again
   cp -f "$RSYSLOGCONF.orig" $RSYSLOGCONF
fi
   # provides TCP syslog reception
   # #module(load="imtcp")
   # #input(type="imtcp" port="514")
   sed -i '/imtcp/s/^#//' $RSYSLOGCONF
   # do same for UDP
   sed -i '/imudp/s/^#//' $RSYSLOGCONF

   awk '
   { print }
   /#### GLOBAL DIRECTIVES ####/ {
    print "$template remote-incoming-logs,\"/var/log/syslog-%HOSTNAME%/%PROGRAMNAME%.log\""
    print "*.* ?remote-incoming-logs"
    print "& ~"
  }
  ' $RSYSLOGCONF > "$RSYSLOGCONF.new"
  mv "$RSYSLOGCONF.new"  $RSYSLOGCONF

	
  sudo systemctl restart rsyslog
  sudo ufw allow 514/tcp
  sudo ufw allow 514/udp
  ss -tunelp | grep 514

