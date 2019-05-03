#!/usr/bin/env bash

cd /home/vagrant/setup
for lxc in `cat lxcs.txt`; do
	echo "Pushing ssh keys for lxc $lxc"
	sudo lxc exec $lxc -- rm -rf /root/.ssh
# Could generate keys for each root user if you like here instead
#	lxc exec $lxc -- ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
	sudo lxc exec $lxc -- mkdir -p /root/.ssh
	cd /home/vagrant/setup
	sudo cat authorized_keys /root/.ssh/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub > foo.keys
	sudo lxc file push foo.keys $lxc/root/.ssh/authorized_keys
	sudo rm -r foo.keys
	sudo lxc exec $lxc -- chmod 700 /root/.ssh
	sudo lxc exec $lxc -- chmod 600 /root/.ssh/authorized_keys
done
