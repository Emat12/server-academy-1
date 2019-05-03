#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive 
sudo dpkg --configure -a

sudo -u root bash -c "DEBIAN_FRONTEND=noninteractive apt-get -yq remove keyboard-configuration plymouth"
sudo -u root bash -c "DEBIAN_FRONTEND=noninteractive apt-get -yq update"
sudo -u root bash -c "DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade"
sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install wget curl pydf htop nano pv screen ccze \
                tcpdump vlan firehol \
                ethtool denyhosts rdist bzip2 \
                etckeeper git-core less unzip mtr-tiny curl gdebi-core \
                rsync psmisc iperf lshw wget pastebinit

