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
sudo apt-get -y install liblwp-authen-negotiate-perl
if [[ ! -f "/var/lib/tomcat8/conf/tomcat-users.xml.orig" ]]; then
	cp -f /var/lib/tomcat8/conf/tomcat-users.xml /var/lib/tomcat8/conf/tomcat-users.xml.orig
else
	cp -f /var/lib/tomcat8/conf/tomcat-users.xml.orig /var/lib/tomcat8/conf/tomcat-users.xml
 awk '
   /<\/tomcat-users>/ {
    print "   "
    print "<role rolename=\"manager-jmx\"/>"
    print "<role rolename=\"manager-gui\"/>"
    print "<role rolename=\"manager-status\"/>"
    print "<role rolename=\"manager\"/>"
    print "<user username=\"munin\" password=\"munin\" roles=\"manager,manager-gui,admin-gui\"/>"
    print "  "
  }
  { print }
  ' /var/lib/tomcat8/conf/tomcat-users.xml > /var/lib/tomcat8/conf/tomcat-users.xml.out
  mv /var/lib/tomcat8/conf/tomcat-users.xml.out /var/lib/tomcat8/conf/tomcat-users.xml

fi

if [[ ! -f "/etc/munin/plugin-conf.d/munin-node.orig" ]]; then
	cp -f /etc/munin/plugin-conf.d/munin-node /etc/munin/plugin-conf.d/munin-node.orig
else
	cp -f /etc/munin/plugin-conf.d/munin-node.orig /etc/munin/plugin-conf.d/munin-node
        cat >> /etc/munin/plugin-conf.d/munin-node  << EOF

[tomcat_*]
env.ports 8080
env.user munin
env.password munin

[jmx_*]
env.ip localhost
env.port 9080

EOF
        cat > /usr/share/tomcat8/bin/setenv.sh <<EOF
JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote=true \
	   -Dcom.sun.management.jmxremote.port=9080 \
           -Dcom.sun.management.jmxremote.ssl=false \
           -Dcom.sun.management.jmxremote.authenticate=false"
EOF
fi

sudo ln -s /usr/share/munin/plugins/tomcat_access /etc/munin/plugins/tomcat_access  > /dev/null 2>&1
sudo ln -s /usr/share/munin/plugins/tomcat_jvm /etc/munin/plugins/tomcat_jvm  > /dev/null 2>&1
sudo ln -s /usr/share/munin/plugins/tomcat_threads /etc/munin/plugins/tomcat_threads  > /dev/null 2>&1
sudo ln -s /usr/share/munin/plugins/tomcat_volume /etc/munin/plugins/tomcat_volume  > /dev/null 2>&1

#1) Files from "plugin" folder must be copied to /usr/share/munin/plugins (or another - where your munin plugins located)
#2) Make sure that jmx_ executable : chmod a+x /usr/share/munin/plugins/jmx_
#3) Copy configuration files that you want to use, from "examples" folder, into /usr/share/munin/plugins folder
#4) create links from the /etc/munin/plugins folder to the /usr/share/munin/plugins/jmx_
#The name of the link must follow wildcard pattern:
#jmx_<configname>,
#where configname is the name of the configuration (config filename without extension), for example:
#ln -s /usr/share/munin/plugins/jmx_ /etc/munin/plugins/jmx_process_memory
cd /root
git clone https://github.com/munin-monitoring/contrib.git
cd /root/contrib/plugins
cp -r /root/contrib/plugins/jmx/plugin/* /usr/share/munin/plugins/
chmod +x /usr/share/munin/plugins/jmx_*
ln -s /usr/share/munin/plugins/jmx_ /etc/munin/plugins/jmx_process_memory



/usr/sbin/munin-node-configure --suggest
/usr/sbin/munin-node-configure --shell | sh
/etc/init.d/munin-node restart

sudo ufw allow 4949/tcp
sudo systemctl enable munin-node
sudo systemctl restart munin-node
sudo systemctl restart tomcat8.service

