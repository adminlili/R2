#!/bin/bash
# for CentOS8

echo -e "\n\n--STEP 1------------------  Install PHP 7.3 on Centos 8  ---------------------\n\n"

chmod +x configs_for_nginx_phpfpm/install_php5673.sh

./configs_for_nginx_phpfpm/install_php5673.sh

yum  -y install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
yum  -y install -y dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm

yum  -y module list php
yum  -y module reset php

yum  -y module enable php:remi-7.3

pkgs="php-fpm php-cli php-mysqlnd php-json php-gd php-ldap php-odbc php-pdo php-opcache \
      php-pear php-xml php-xmlrpc php-mbstring php-snmp php-soap php-zip"

for p in $pkgs;
do
    yum  -y install $p
done

php -v

yum  install -y make

# disable selinux temporarely
setenforce 0
# disable selinux permanently
sed  -i 's/^SELINUX=.*$/SELINUX=disabled/' /etc/selinux/config

systemctl stop firewall
systemctl enable iptables
systemctl restart iptables

iptables -I INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 443 -j ACCEPT

# allow all Incoming HTTP
iptables -I INPUT -p tcp -m conntrack --dport 80 --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -I OUTPUT -p tcp -m conntrack --sport 80 --ctstate ESTABLISHED -j ACCEPT

# allow all Incoming HTTPS
iptables -I INPUT -p tcp -m conntrack --dport 443 --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -I OUTPUT -p tcp -m conntrack --sport 443 --ctstate ESTABLISHED -j ACCEPT


iptables-save > /etc/sysconfig/iptables
systemctl restart iptables
systemctl status iptables | grep active

#chown -R $(whoami):$(whoami) /usr/share/nginx/

echo -e "\n\n--STEP 2---------  Copying configs from local to needed destinations ----------\n"

cp configs_for_nginx_phpfpm/www.conf /etc/php-fpm.d/www.conf
cp -r configs_for_nginx_phpfpm/php56 /etc/opt/remi/
cp -r configs_for_nginx_phpfpm/php73 /etc/opt/remi/
cp -r configs_for_nginx_phpfpm/usr_share_nginx_html/* /usr/share/nginx/html/
cp -r configs_for_nginx_phpfpm/etc_nginx_confd/* /etc/nginx/conf.d/

#chown www-data:www-data -R /var/log/php*
#chown www-data:www-data -R /usr/share/nginx/html/*

mkdir -p /var/log/php-fpm/
touch /var/log/php-fpm/error.log

chown -R nginx:nginx /var/log/*php*
chown -R nginx:nginx /usr/share/nginx/html
chmod -R 755 /usr/share/nginx/html

echo  -e "\n\n------------------ STATUS of PHP-FPM for DEFAULT PHP ------------------\n"
systemctl restart php-fpm
systemctl status php-fpm | grep active

echo  -e "\n\n--------------------- STATUS of PHP-FPM for PHP-5.6 ------------------\n"
systemctl restart php56-php-fpm
systemctl status php56-php-fpm | grep active

echo  -e "\n\n--------------------- STATUS of PHP-FPM for PHP-7.3 ------------------\n"
systemctl restart php73-php-fpm
systemctl status php73-php-fpm | grep active

echo  -e "\n----------------------- STATUS of NGINX --------------------------------\n"
systemctl restart nginx
systemctl status nginx | grep active

echo -e "\n\n--STEP 3--------- Testing Database Connection from PHP ----------------------"
echo -e "----------------- Is PHP able to connect to MAriDB/Mysql and  ---------------"
echo -e "----------------- execute databases queries?  -------------------------------"

PASS_mysql='123L45p68'

echo -e 'SELECT * FROM nginx_test.todo_list;' | mysql -uroot -p$PASS_mysql

# ./1.sh Hello World
# $0 = ./1.sh
# $1 = Hello
# $2 = World
# if command executed successfully it will returned 0 if no - 1

if [ $? -eq 0 ]
then
	echo -e "\n\tCongratulations!!!"
	echo -e "\tPHP environment is ready to connect and interact with MariaDB/Mysql server!!!"
else
    echo -e "\nError!! PHP-FPM have problems with work with MariaDB/Mysql.\n"
fi
