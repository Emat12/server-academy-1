#!/bin/bash

cd /home/vagrant/setup
service postgresql stop
chown -R postgres:postgres /data/pgdata/
rsync -av /var/lib/postgresql/10/main/ /data/pgdata/
service postgresql start


