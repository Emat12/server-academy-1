#!/bin/bash

# Configure the APache2 server with the appropriate hostname for this virtual host

##  This is  stuff to remove the instructor files  -- bad example
rm -rf /var/www/instructor.dar.dhis2.site 
##

HOSTN=$1
INDEXHTML='/var/www/apache2/index.html.orig'
ENTTITLE='DHIS2 Academy Dar es Salaam 2019'
echo "$0 Assuming hostname for Apache2 Configuratation:  $HOSTN"

cat > /tmp/web.conf <<EOF
<VirtualHost *:80>
    ServerName {HOSTNAME}
    DocumentRoot /var/www/{HOSTNAME}/public_html
    ErrorLog ${APACHE_LOG_DIR}/{HOSTNAME}-error.log
    CustomLog ${APACHE_LOG_DIR}/{HOSTNAME}-access.log combined
    #Options +Includes
    AddHandler server-parsed .html
    <Directory /var/www/{HOSTNAME}/public_html>
        Options +Includes +FollowSymLinks
	AllowOverride All
    </Directory>
    ##START
    Include dhis2.conf
    ##STOP
</VirtualHost>
EOF
cp $INDEXHTML /tmp/index.html
perl -pi -e "s|{HOSTNAME}|$HOSTN|sig" /tmp/web.conf

#<!--#set var="Ent-Title" value="{ENTTITLE}" -->
#<!--#set var="EntHead1" value="{ENTHEAD1}" -->
#<!--#set var="EntHead2" value="{ENTHEAD2}" -->
perl -pi -e "s|{ENTTITLE}|$ENTTITLE - $HOSTN|sig" /tmp/index.html
perl -pi -e "s|{ENTHEAD1}|$HOSTN|sig" /tmp/index.html
perl -pi -e "s|{ENTHEAD2}|$ENTTITLE|sig" /tmp/index.html

sudo a2enmod include 
sudo a2enmod proxy
sudo a2enmod proxy_http
#sudo a2enmod proxy_ajp
sudo a2enmod rewrite
sudo a2enmod deflate
sudo a2enmod headers
sudo a2enmod proxy_balancer
sudo a2enmod proxy_connect
#sudo a2enmod proxy_html

# Move the default index.html page
DEFHTML='/var/www/html/index.html'
if [[ ! -f "$DEFHTML.orig" ]]; then
mv $DEFHTML "$DEFHTML.orig"
else
#  echo "<H1> $ENTTITLE </H1>" >  $DEFHTML	
  echo "<H2> GO AWAY.  NO ACCESS BY IP ADDRESS.  </H2>" > $DEFHTML
#  echo "<br/><br/>Instead please visit: <a href=\"http://$HOSTN\">$HOSTN</a>" >> $DEFHTML
fi


mkdir -p /var/www/$HOSTN/public_html
mv /tmp/index.html /var/www/$HOSTN/public_html
cp -r /var/www/apache2/* /var/www/$HOSTN/public_html/
chown -R www-data: /var/www/$HOSTN
#touch /etc/apache2/dhis2.conf

mv /tmp/web.conf /etc/apache2/sites-available/$HOSTN.conf

sudo a2ensite $HOSTN

sudo systemctl restart apache2


