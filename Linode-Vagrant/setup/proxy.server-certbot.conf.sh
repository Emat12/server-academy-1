#!/bin/bash

# Configure the APache2 server with the appropriate hostname for this virtual host

HOSTN=$1

echo "$0 Assuming hostname for CertBot Configuration:  $HOSTN"

sudo certbot --apache -d $HOSTN --redirect --non-interactive --agree-tos -m webmaster@dhis2.org

sudo systemctl restart apache2


