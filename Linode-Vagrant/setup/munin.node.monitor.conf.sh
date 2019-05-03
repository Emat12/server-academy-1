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
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install liblwp-protocol-socks-perl

sudo ln -s /usr/share/munin/plugins/apache_processes /etc/munin/plugins/apache_processes > /dev/null 2>&1
sudo ln -s /usr/share/munin/plugins/apache_accesses /etc/munin/plugins/apache_accesses > /dev/null 2>&1
sudo ln -s /usr/share/munin/plugins/apache_volume /etc/munin/plugins/apache_volume > /dev/null 2>&1

/usr/sbin/munin-node-configure --suggest
/usr/sbin/munin-node-configure --shell | sh
/etc/init.d/munin-node restart

sudo ufw allow 4949/tcp
sudo systemctl enable munin-node
sudo systemctl restart munin-node

