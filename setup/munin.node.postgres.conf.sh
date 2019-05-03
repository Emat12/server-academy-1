#!/bin/bash

# This will make whatever server it is run on a complete listening munin host
MUNINCONF='/etc/munin/munin-node.conf'

if [[ ! -f "$MUNINCONF.orig" ]]; then
   # likely a 1st time run
   sudo DEBIAN_FRONTEND=noninteractive apt-get -y update
   sudo DEBIAN_FRONTEND=noninteractive apt-get -y install munin-plugins-core munin-plugins-extra munin-node
   sudo DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
   sudo ufw allow 4949/tcp
   # save a copy of the original distro conf file
   cp -f $MUNINCONF "$MUNINCONF.orig"
else
	# reset and try again
   cp -f "$MUNINCONF.orig" $MUNINCONF
fi

cat >> $MUNINCONF <<EOF
# Open Access to monitor
cidr_allow 192.168.0.0/24
EOF

# lxc specific operations

sudo DEBIAN_FRONTEND=noninteractive apt-get -y install libdbd-pg-perl
/usr/sbin/munin-node-configure --suggest
/usr/sbin/munin-node-configure --shell | sh
/etc/init.d/munin-node restart

sudo ufw allow 4949/tcp
sudo systemctl enable munin-node
sudo systemctl restart munin-node

