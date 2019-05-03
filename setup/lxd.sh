# Host machine setup 
# Assumptions:
# /dev/sdc exists and will be used for lxc storage (zfs)
# /dev/sdd exists and will be used for postgres encrypted data partition

BRIDGE="lxdbr0"

# lest we forget to enable firewall ...
sudo ufw limit 22/tcp
sudo ufw enable

sudo apt install zfsutils-linux
 
# for the moment this is interactive ... automate this
# note "lxd init --dump" is in latest bleeding edge
lxd init 
 
# create containers from ubuntu 18.04 base image
# todo - create specialised pre-configured images?
for m in proxy tomcat postgres monitor; lxc init ubuntu: $m; done

# network setup
for m in proxy tomcat postgres monitor; lxc network attach $BRIDGE $m eth0 eth0; done
lxc config device set proxy eth0 ipv4.address 192.168.0.2
lxc config device set tomcat eth0 ipv4.address 192.168.0.3
lxc config device set database eth0 ipv4.address 192.168.0.10
lxc config device set monitor eth0 ipv4.address 192.168.0.20

# first stab at resource allocations
## We divide up the 6 cpus.  Because they are so few might be better to use limits.cpu.priority 
## and/or limits.cpu.allowance for more fine grained sharing.
lxc config set tomcat limits.cpu 2
lxc config set postgres limits.cpu 2
lxc config set proxy limits.cpu 1

# just give monitor low priority to scavenge what is available
lxc config set monitor limits.cpu.priority 1

lxc config set tomcat limits.memory 6GB
lxc config set postgres limits.memory 6GB
lxc config set proxy limits.memory 1GB
lxc config set monitor limits.memory 512MB

 
