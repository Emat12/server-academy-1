#!/bin/bash

#must be run as root
HOSTSFN='/etc/hosts'
if [[ ! -f "$HOSTSFN/orig" ]]; then
 sudo cp -f $HOSTSFN "$HOSTSFN.orig"
else 
 sudo cp -f "$HOSTSFN.orig" $HOSTSFN
fi
 sudo cat <<EOF >> /etc/hosts

#These hosts added so that they can esasily be resolved by lxd host
192.168.0.1 host
192.168.0.2 proxy proxy.lxd
192.168.0.3 tomcat tomcat.lxd
192.168.0.10 postgres postgres.lxd
192.168.0.20 monitor monitor.lxd
EOF
 
