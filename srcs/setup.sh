#!/bin/bash

SRCS_DIR=/tmp
SRVR_DIR=/var/www
SITE_DIR=$SRVR_DIR/localhost
CERT_DIR=/etc/ssl/certs
#CRT_PRMT=-x509 -nodes -days 365 -newkey rsa:2048

########### apt packages installation
apt install -y nano curl nginx mariadb-server php-fpm php-mysql php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip php-json

########### services initial start
service nginx start
service mysql start
service php7.3-fpm start

########### certification key generation
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=BR/ST=SP/L=SP/O=JunorCorp/CN=GreatJunor' -keyout $CERT_DIR/localhost.key -out $CERT_DIR/localhost.crt

########### nginx configuration
mkdir $SITE_DIR
chown -R $USER:$USER $SITE_DIR

rm /etc/nginx/sites-*/default

mv $SRCS_DIR/nginx.conf /etc/nginx/sites-available

ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/

########### wordpress configuration
mysql -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
mysql -e "GRANT ALL ON wordpress.* TO 'wp_user'@'localhost' IDENTIFIED BY 'wordpress';"
mysql -e "FLUSH PRIVILEGES;"

cd $SRCS_DIR 
tar -zxvf latest.tar.gz 

mv $SRCS_DIR/wordpress $SITE_DIR/wordpress

chown -R www-data:www-data $SITE_DIR/wordpress

mv $SRCS_DIR/wp-config.php $SITE_DIR/wordpress

curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> $SRVR_DIR/wordpress/wp-config.php

########### phpMyAdmin configuration
tar -zxvf phpMyAdmin-latest-all-languages.tar.gz
mv phpMyAdmin-*-all-languages $SITE_DIR/phpMyAdmin

mv $SRCS_DIR/config.inc.php $SITE_DIR/phpMyAdmin

mysql < $SITE_DIR/phpMyAdmin/sql/create_tables.sql -u root

mysql -e "GRANT ALL ON phpmyadmin.* TO 'pma'@'localhost' IDENTIFIED BY 'pmapass';"
mysql -e "FLUSH PRIVILEGES;"

mkdir $SITE_DIR/phpMyAdmin/tmp
chmod 777 $SITE_DIR/phpMyAdmin/tmp
chown -R www-data:www-data $SITE_DIR/phpMyAdmin

mysql -e "CREATE DATABASE app_db;"
mysql -e "GRANT ALL ON app_db.* TO 'app_user'@'localhost' IDENTIFIED BY 'password';"
mysql -e "FLUSH PRIVILEGES;"

########### clear setup directory
#mv services.sh ..
#rm /tmp/*
#mv ../services.sh .

########### services restart and setup end
service nginx restart
service mysql restart
service php7.3-fpm restart
