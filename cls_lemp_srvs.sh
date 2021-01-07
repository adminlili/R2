#!/bin/bash

yum -y remove mysql-community-server MariaDB-server nginx php-fpm
yum erase mysql57-community-server

rm -f /etc/my.cnf

rm -rf /var/log/mysql*

userdel -r nginx_user
