#!/bin/bash

yum -y remove mysql-community-server MariaDB-server
yum erase mysql57-community-server

rm -f /etc/my.cnf
rm -rf /var/log/mysql*

userdel -r nginx_user
