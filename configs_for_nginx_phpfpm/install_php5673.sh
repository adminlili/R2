#!/bin/bash


# php 5.6
yum install php56-php-bcmath php56-php-common php56-php-gd php56-php-intl\
 php56-php-ioncube-loader php56-php-litespeed php56-php-mbstring\
 php56-php-mcrypt php56-php-mysqlnd php56-php-opcache php56-php-pdo\
 php56-php-pecl-jsonc php56-php-pecl-zip php56-php-soap php56-php-xml\
 php56-runtime php56-php-fpm php56-php-cgi php-zip -y

#php 7.3
dnf module install php:remi-7.3
dnf install php73-php-bcmath php73-php-common php73-php-gd php73-php-intl\
 php73-php-ioncube-loader php73-php-litespeed php73-php-mbstring php73-php-mcrypt\
 php73-php-mysqlnd php73-php-opcache php73-php-pdo\
 php73-php-pecl-zip php73-php-soap php73-php-xml php73-runtime php73-php-fpm\
 php73-php-cgi php-zip -y 


#dnf install php-bcmath php-common php-gd php-intl php-ioncube-loader php-litespeed\
# php-mbstring php-mcrypt php-mysqlnd php-opcache php-pdo php-pecl-zip php-soap\
# php-xml php-zip -y


# after installing need some changes in configs

chown -R root:nginx /var/lib/php
chown -R root:nginx /var/www/nginx

chmod -R o+r /var/www

dnf module list php
dnf module disable php -y
dnf module reset php -y
dnf module enable php:remi-7.3 -y
dnf module enable php:remi-5.6 -y
dnf module list php

systemctl enable php-fpm
systemctl enable php73-php-fpm
systemctl enable php56-php-fpm
systemctl enable nginx

systemctl restart nginx
systemctl restart php-fpm
systemctl restart php56-php-fpm
systemctl restart php73-php-fpm
