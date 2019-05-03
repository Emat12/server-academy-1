#!/usr/bin/env bash

cd /home/vagrant/setup


#Final things for  PostgreSQL

SRV='postgres'
SFILE='postgres.final.conf.sh'
ssh -o StrictHostKeyChecking=no root@$SRV  "bash -s" < $SFILE


# Setup DHIS2 Database
SRV='tomcat'
sudo /home/vagrant/setup/dhis2-instance-create dhis $SRV
sleep 2
ssh -o StrictHostKeyChecking=no root@$SRV  "service tomcat8 restart"

# Setup our repository from Github 
