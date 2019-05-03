#!/bin/bash

# Setup basic access to each VM

BADPASSWD='!DarAdm1n'
sudo adduser --disabled-password --gecos "" dar-admin
sudo usermod -aG sudo dar-admin
echo -e "$BADPASSWD\n$BADPASSWD" | (passwd dar-admin)
sudo su - dar-admin -c "echo -e $BADPASSWD > /home/dar-admin/password.txt"
sudo chmod
sudo su - dar-admin -c "yes | ssh-keygen -t rsa -N \"\" -f /home/dar-admin/.ssh/id_rsa"
sudo cp /home/vagrant/setup/authorized_keys /home/dar-admin/.ssh/

sudo chown -R dar-admin.dar-admin /home/dar-admin/.ssh/
sudo chmod 700 /home/dar-admin/.ssh
sudo chmod 600 /home/dar-admin/.ssh/authorized_keys

