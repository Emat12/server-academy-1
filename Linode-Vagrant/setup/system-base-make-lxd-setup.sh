#!/bin/bash

cd /home/vagrant/setup

DISKVOLLXD='/dev/sdc2'

echo "Refreshing lxd"
zudo zpool -f destroy default  > /dev/null 2>&1
sudo DEBIAN_FRONTEND=noninteractive apt-get -y purge lxd
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install lxd lxd-tools

echo "Install ZFS if required "
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install zfsutils-linux 

echo "lxd init ... "
cat << EOF | lxd init --preseed
config: {}
networks:
- config:
    ipv4.address: 192.168.0.1/24
    ipv4.nat: "true"
    ipv6.address: none
  description: ""
  managed: false
  name: lxdbr0
  type: ""
storage_pools:
- config:
    source: $DISKVOLLXD
  description: ""
  name: default
  driver: zfs
profiles:
- config: {}
  description: ""
  devices:
    eth0:
      name: eth0
      nictype: bridged
      parent: lxdbr0
      type: nic
    root:
      path: /
      pool: default
      type: disk
  name: default
cluster: null
EOF


sleep 3

# get images from instructor
lxc remote add instructor 178.79.181.151 --public --accept-certificate
lxc init instructor:dhis2-proxy proxy 
lxc init instructor:dhis2-tc tomcat  
lxc init instructor:dhis2-pg postgres 
lxc init instructor:dhis2-monitor monitor 

# configuration settings for lxc containers
lxc config device remove proxy eth0
lxc config device remove tomcat eth0
lxc config device remove postgres eth0
lxc config device remove monitor eth0
lxc config device set proxy eth0 ipv4.address 192.168.0.2
lxc config device set tomcat eth0 ipv4.address 192.168.0.3
lxc config device set monitor eth0 ipv4.address 192.168.0.20
lxc config device set postgres eth0 ipv4.address 192.168.0.10
lxc network attach lxdbr0 proxy eth0 eth0
lxc network attach lxdbr0 tomcat eth0 eth0
lxc network attach lxdbr0 postgres eth0 eth0
lxc network attach lxdbr0 monitor eth0 eth0

lxc config device add proxy myport80 proxy listen=tcp:0.0.0.0:80 connect=tcp:192.168.0.2:80
lxc config device add proxy myport443 proxy listen=tcp:0.0.0.0:443 connect=tcp:192.168.0.2:443

sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo yes |  ufw enable

# revise these
#lxc config set tomcat limits.cpu 2
#lxc config set postgres limits.cpu 2
#lxc config set proxy limits.cpu 1
#lxc config set monitor limits.cpu 1
#lxc config set tomcat limits.memory 6GB
#lxc config set postgres limits.memory 6GB
#lxc config set proxy limits.memory 1GB
#lxc config set monitor limits.memory 512MB

lxc config set tomcat boot.autostart false
lxc config set postgres boot.autostart false

# add encrypted data to postgres
lxc config device add postgres cryptdata disk source=/dev/VG_cryptdata/LV_cryptdata path=/data
lxc start monitor
lxc start proxy
lxc list

