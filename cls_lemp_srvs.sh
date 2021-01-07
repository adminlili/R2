#!/bin/bash

yum -y remove mysql-community-server MariaDB-server nginx \
 php-fpm php56-php-fpm php73-php-fpm except
yum erase mysql57-community-server

rm -f /etc/my.cnf
rm -rf  /etc/nginx/conf.d/*
rm -rf /var/log/mysql*

userdel -r nginx_user
