#!/bin/bash

# This will make whatever server it is run on a complete listening rsyslogd host

sudo apt-get -y update
sudo apt-get -y install software-properties-common 
sudo add-apt-repository universe && sudo add-apt-repository ppa:certbot/certbot
sudo apt-get -y update

# Note this installs Apache as well
sudo apt-get -y install python-certbot-apache

sudo apt-get -y autoremove

sudo ufw allow "Apache Full"

sudo ufw status
sudo systemctl status apache2
sudo systemctl restart apache2

# This cleans out old installs completely .   Be careful
rm -rf /etc/letsencrypt/live/*dhis2.site*  > /dev/null 2>&1
rm -rf /etc/apache2/sites-available/*dhis2.site* > /dev/null 2>&1
rm -rf /etc/apache2/sites-enabled/*dhis2.site* > /dev/null 2>&1


