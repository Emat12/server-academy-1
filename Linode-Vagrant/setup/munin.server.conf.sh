#!/bin/bash

# This will make whatever server it is run on a complete listening munin host
MUNINCONF='/etc/munin/munin.conf'
MUNINA2CONF='/etc/munin/apache24.conf'

if [[ ! -f "$MUNINCONF.orig" ]]; then
   # likely a 1st time run
   sudo DEBIAN_FRONTEND=noninteractive apt-get -y update
   sudo DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 libcgi-fast-perl libapache2-mod-fcgid
   a2enmod fcgid
   a2enmod status
   sudo DEBIAN_FRONTEND=noninteractive apt-get -y install munin
   sudo DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
   sudo ufw allow "Apache Full"
   sudo systemctl status apache2
   sudo systemctl restart apache2
   # save a copy of the original distro conf file
   cp -f $MUNINCONF "$MUNINCONF.orig"
   cp -f $MUNINA2CONF "$MUNINA2CONF.orig"
   cp -f /etc/munin/munin-node.conf /etc/munin/munin-node.conf.orig
else
	# reset and try again
   cp -f "$MUNINCONF.orig" $MUNINCONF
   cp -f "$MUNINA2CONF.orig" $MUNINA2CONF
fi
   # Activate the server for operations 
   sed -i '/dbdir/s/^#//' $MUNINCONF
   sed -i '/htmldir/s/^#//' $MUNINCONF
   sed -i '/logdir/s/^#//' $MUNINCONF
   sed -i '/rundir/s/^#//' $MUNINCONF
   sed -i '/tmpldir/s/^#//' $MUNINCONF

   # Fix up Apache2
   perl -pi -e "s|Require local|Require all granted|sig" $MUNINA2CONF
   ln -s $MUNINA2CONF /etc/apache2/conf-available/munin.conf  > /dev/null 2>&1
   a2enconf munin.conf

   #Also add hosts as required to the config file
   perl -pi -e "s|localhost.localdomain|monitor.lxd|sig" $MUNINCONF

   cat >> $MUNINCONF <<EOF
[tomcat.lxd]
    address 192.168.0.3
    use_node_name yes

[postgres.lxd]
    address 192.168.0.10
    use_node_name yes

[proxy.lxd]
    address 192.168.0.2
    use_node_name yes

[ThisLinodeVM.LinodeHosts]
    address 192.168.0.1
    use_node_name yes
EOF

  sudo systemctl restart apache2
  sudo ufw allow 80/tcp
  sudo ufw allow 443/tcp

