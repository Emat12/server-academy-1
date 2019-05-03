#!/bin/bash

# This section creates a new luks encrypted from /dev/sdd using a weak password
# The encrypted disk is used for a logical volume which is formatted and added
# to the postgres container mounted at /data
#
# POSTSETUP:  You need to add one or more strong passwords to the luks disk
#             and remove the existing weak one.
#
#             cryptsetup luksAddKey /dev/sdd'
#             cryptsetup luksRemoveKey /dev/sdd

CRYPTDSK='/dev/sdc1'
WEAKPASSWD="WeakP@ssword"
# root user on the container TODO: query this from /etc/subuid, /etc/subgid
Container_UID=100000
Container_GID=100000

export DEBIAN_FRONTEND=noninteractive

#apt update -y
#apt dist-upgrade -y

echo "Creating encrypted disk from /dev/sdd"
echo -n $WEAKPASSWD | cryptsetup luksFormat $CRYPTDSK -
echo -n $WEAKPASSWD | cryptsetup luksOpen $CRYPTDSK cryptdata -
echo "Setting up lvm"
sudo pvcreate PV_cryptdata /dev/mapper/cryptdata
sudo vgcreate VG_cryptdata /dev/mapper/cryptdata
sudo lvcreate --name LV_cryptdata -l 100%FREE VG_cryptdata

sudo mkfs -t ext4 /dev/VG_cryptdata/LV_cryptdata
mkdir tmp
sudo mount /dev/VG_cryptdata/LV_cryptdata tmp
mkdir tmp/pgdata
chown -R $Container_UID:$Container_GID tmp/*
sudo umount tmp
rmdir tmp

echo "Disk setup done" 
echo "Now you need to add a new key to the encrypted disk and renove the default"
echo "Using 'cryptsetup luksAddKey $CRYPTDSK' AND 'cryptsetup luksRemoveKey $CRYPTDSK'"

###################################################################################################


