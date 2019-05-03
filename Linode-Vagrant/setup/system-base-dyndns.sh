#!/usr/bin/env bash
#
# eSHIFT / HISP Geneva - For Dar es Salaam UiO Systems Admin Academy
# "Steven Uggowitzer" <whotopia@gmail.com>
#
# This file can be run repeatedly with no problems

# Will set the hostname for Dyndns via Namecheap (Entuura/eSHIFT domain dhis.site)
# FQ Host name will be  xxx.dar.dhis2.site
#
# Valid HostName values are:
# instructor, build01, build02, build03,
# team01, team02, team03, team04, team05, team06,team07, team08,team09, team10
# team11, team12, team13, team14, team15, team16

if [ "$#" -eq  "0" ]
   then
     echo "No arguments supplied"
     echo "Defaulting to 'instructor'"
     HostName='instructor'
   else

   if [[ "$1" =~ ^(instructor|build01|build02|build03|team01|team02|team03|team04|team05|team06|team07|team08|team09|team10|team11|team12|team13|team14|team15|team16|team17|team18)$ ]]; then
        HostName="$1"
        echo "Using $HostName"
   else
        echo "Not a valid hostname"
        exit;
   fi
fi


sudo DEBIAN_FRONTEND=noninteractive apt-get -y remove ddclient
sudo DEBIAN_FRONTEND=noninteractive apt-get -y autoremove

sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install ddclient

## Setup to create the correct configuration file
DOMAIN="dhis2\.site"
SubSubDomain='dar'
SubDomain="$SubSubDomain.$DOMAIN"
FQHOST="$HostName.$SubDomain"
PQHOST="$HostName.$SubSubDomain"

NamecheapPasswd='7f1efc1c3c3744dfb465643c9a04d529'
DDClientFile='/etc/ddclient.conf'
cat > /tmp/ddclient.conf <<- "EOF"
# Configuration file for ddclient
# DHIS2 Server Academy
# /etc/ddclient.conf
daemon=300
ssl=yes
use=web, web=dynamicdns.park-your-domain.com/getip
protocol=namecheap
server=dynamicdns.park-your-domain.com
EOF
sudo mv /tmp/ddclient.conf $DDClientFile
sudo chown root.root $DDClientFile
sudo chmod 600 $DDClientFile

sudo echo "login=$DOMAIN" >> $DDClientFile
sudo echo "password=$NamecheapPasswd" >> $DDClientFile
sudo echo $PQHOST >> $DDClientFile

sudo perl -pi -e "s|run_daemon=\"false\"|run_daemon=\"true\"|sig" /etc/default/ddclient

sudo systemctl enable ddclient.service
sudo systemctl stop ddclient.service
sudo systemctl start ddclient.service
#sudo systemctl status ddclient.service

sudo hostnamectl set-hostname $FQHOST


