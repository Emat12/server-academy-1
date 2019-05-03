#!/bin/bash

# For this configuration the additional disk /dev/sdc is assumed to exist
# it is then split with 65 GB assigned to /dev/sdc1 and the rest to /dev/sdc2
# This was designed to work on Linode.  Your mileage my vary for other installations

# Disk for the database and containers 
DISKVOL='/dev/sdc'
DISKVOLPGDATA='/dev/sdc1'
DISKVOLLXD='/dev/sdc2'

# First format the disk according to requirements
sudo sfdisk --force $DISKVOL << EOF
label: dos
label-id: 0x480b729e
device: $DISKVOL
unit: sectors

$DISKVOLPGDATA : start=        2048, size=   136314880, type=83
$DISKVOLLXD : start=   136316928, size=   135690240, type=83
EOF


