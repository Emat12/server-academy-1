#!/usr/bin/env bash

# This script will refresh all the packages in an lxc container
export DEBIAN_FRONTEND=noninteractive 

sudo dpkg --configure -a

sudo sh -c 'apt-get -y update && apt-get -y upgrade'

sudo apt-get -y install wget curl pydf htop nano pv screen ccze \
                tcpdump vlan firehol \
                ethtool denyhosts rdist bzip2 \
                etckeeper git-core less unzip mtr-tiny curl gdebi-core \
                rsync psmisc iperf lshw wget pastebinit


