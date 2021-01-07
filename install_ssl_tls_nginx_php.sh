#!/bin/bash
echo -e  "\n--STEP 1------------------------ disable SELINUX  --------------------------------\n"

sed 's/SELINUX="permissive"|"enforcing"|"disabled"/SELINUX=disabled/' /etc/selinux/config

setenforce 0

systemctl stop firewalld
systemctl enable nginx
systemctl start nginx

echo -e  "\n--STEP 2-------------------- Create the SSL Certificate  ------------------------\n"
# for public certs
mkdir /etc/ssl/certs
chmod 740 /etc/ssl/certs/nginx

mkdir /etc/ssl/certs/nginx/fqdn-lixhm.local
mkdir /etc/ssl/certs/nginx/fqdn-maindnssrv.lixhm.local
mkdir /etc/ssl/certs/nginx/fqdn-ftp.lixhm.local
mkdir /etc/ssl/certs/nginx/fqdn-www.lixhm.local
mkdir /etc/ssl/certs/nginx/fqdn-testpc1.lixhm.local
mkdir /etc/ssl/certs/nginx/fqdn-testpc2.lixhm.local
mkdir /etc/ssl/certs/nginx/fqdn-mail1.lixhm.local

# for private certs
mkdir /etc/ssl/private
chmod 700 /etc/ssl/private/nginx

mkdir /etc/ssl/private/nginx/fqdn-lixhm.local
mkdir /etc/ssl/private/nginx/fqdn-maindnssrv.lixhm.local
mkdir /etc/ssl/private/nginx/fqdn-ftp.lixhm.local
mkdir /etc/ssl/private/nginx/fqdn-www.lixhm.local
mkdir /etc/ssl/private/nginx/fqdn-testpc1.lixhm.local
mkdir /etc/ssl/private/nginx/fqdn-testpc2.lixhm.local
mkdir /etc/ssl/private/nginx/fqdn-mail1.lixhm.local

echo -e "\n-------------------------  for domain maindnssrv.lixhm.local ----------------------\n"
openssl req -x509 -days 3650 -nodes \
 -newkey rsa:2048 -keyout /etc/ssl/private/nginx/fqdn-maindnssrv.lixhm.local/fqdn-maindnssrv.lixhm.local-selfsigned.key \
 -out /etc/ssl/certs/nginx/fqdn-maindnssrv.lixhm.local/fqdn-maindnssrv.lixhm.local-selfsignedP.crt \
 -subj "/C=UA/ST=Dnipro/L=Dnipro/O=Global Security/OU=IT Department/CN=maindnssrv.lixhm.local/CN=maindnssrv"


echo -e "\n-------------------------  for domain www.lixhm.local ----------------------\n"
openssl req -x509 -days 3650 -nodes \
 -newkey rsa:2048 -keyout /etc/ssl/private/nginx/fqdn-www.lixhm.local/fqdn-www.lixhm.local-selfsigned.key \
 -out /etc/ssl/certs/nginx/fqdn-www.lixhm.local/fqdn-www.lixhm.local-selfsignedP.crt \
 -subj "/C=UA/ST=Dnipro/L=Dnipro/O=Global Security/OU=IT Department/CN=www.lixhm.local/CN=www"


echo -e "\n-------------------------  for domain mail1.lixhm.local ----------------------\n"
openssl req -x509 -days 3650 -nodes \
 -newkey rsa:2048 -keyout /etc/ssl/private/nginx/fqdn-mail1.lixhm.local/fqdn-mail1.lixhm.local-selfsigned.key \
 -out /etc/ssl/certs/nginx/fqdn-mail1.lixhm.local/fqdn-mail1.lixhm.local-selfsignedP.crt \
 -subj "/C=UA/ST=Dnipro/L=Dnipro/O=Global Security/OU=IT Department/CN=mail1.lixhm.local/CN=mail1"


echo -e "\n-------------------------  for domain testpc1.lixhm.local ----------------------\n"
openssl req -x509 -days 3650 -nodes \
 -newkey rsa:2048 -keyout /etc/ssl/private/nginx/fqdn-testpc1.lixhm.local/fqdn-testpc1.lixhm.local-selfsigned.key \
 -out /etc/ssl/certs/nginx/fqdn-testpc1.lixhm.local/fqdn-testpc1.lixhm.local-selfsignedP.crt \
 -subj "/C=UA/ST=Dnipro/L=Dnipro/O=Global Security/OU=IT Department/CN=testpc1.lixhm.local/CN=testpc1"


echo -e "\n-------------------------  for domain testpc2.lixhm.local ----------------------\n"
openssl req -x509 -days 3650 -nodes \
 -newkey rsa:2048 -keyout /etc/ssl/private/nginx/fqdn-testpc2.lixhm.local/fqdn-testpc2.lixhm.local-selfsigned.key \
 -out /etc/ssl/certs/nginx/fqdn-testpc2.lixhm.local/fqdn-testpc2.lixhm.local-selfsignedP.crt \
 -subj "/C=UA/ST=Dnipro/L=Dnipro/O=Global Security/OU=IT Department/CN=testpc2.lixhm.local/CN=testpc2"


echo -e "\n-------------------------  for domain ftp.lixhm.local ----------------------\n"
openssl req -x509 -days 3650 -nodes \
 -newkey rsa:2048 -keyout /etc/ssl/private/nginx/fqdn-ftp.lixhm.local/fqdn-ftp.lixhm.local-selfsigned.key \
 -out /etc/ssl/certs/nginx/fqdn-ftp.lixhm.local/fqdn-ftp.lixhm.local-selfsignedP.crt \
 -subj "/C=UA/ST=Dnipro/L=Dnipro/O=Global Security/OU=IT Department/CN=ftp.lixhm.local/CN=ftp"


echo -e  "\n--STEP 3---------- Create strong Diffie-Hellman group which used in  ------------"
echo -e "--------------------- negotiating Perfect Forward Secrecy with clients. -------------\n"

echo -e "\n-------------------------  for domain maildnssrv.lixhm.local ----------------------\n"
openssl dhparam -out /etc/ssl/certs/nginx/fqdn-maindnssrv.lixhm.local/fqdn-maindnssrv.lixhm.local-selfsigned-dhparam.pem 2048

echo -e "\n-------------------------  for domain ftp.lixhm.local ----------------------\n"
openssl dhparam -out /etc/ssl/certs/nginx/fqdn-ftp.lixhm.local/fqdn-ftp.lixhm.local-selfsigned-dhparam.pem 2048

echo -e "\n-------------------------  for domain www.lixhm.local ----------------------\n"
openssl dhparam -out /etc/ssl/certs/nginx/fqdn-www.lixhm.local/fqdn-www.lixhm.local-selfsigned-dhparam.pem 2048

echo -e "\n-------------------------  for domain testpc1.lixhm.local ----------------------\n"
openssl dhparam -out /etc/ssl/certs/nginx/fqdn-testpc1.lixhm.local/fqdn-testpc1.lixhm.local-selfsigned-dhparam.pem 2048

echo -e "\n-------------------------  for domain testpc2.lixhm.local ----------------------\n"
openssl dhparam -out /etc/ssl/certs/nginx/fqdn-testpc2.lixhm.local/fqdn-testpc2.lixhm.local-selfsigned-dhparam.pem 2048

echo -e "\n-------------------------  for domain mail1.lixhm.local ----------------------\n"
openssl dhparam -out /etc/ssl/certs/nginx/fqdn-mail1.lixhm.local/fqdn-mail1.lixhm.local-selfsigned-dhparam.pem 2048

echo -e  "\n--STEP 4----------------------- Configure Nginx to use SSL ----------------------\n"

cp etc_nginx_ssl_nginx_conf /etc/nginx/nginx.conf

echo -e "\n------- Checking status of NGINX (is it good work with TLS/SSL configs) ---------\n"
echo -e $(nginx -s reload) && echo -e $(nginx -t) && echo -e  "\n"
systemctl restart nginx
systemctl status nginx | grep active

echo -e  "\n------- Checking status of PHP56-PHP-FPM (is it good work with TLS/SSL configs) ---------\n"
systemctl restart php56-php-fpm
systemctl status php56-php-fpm | grep active

echo -e  "\n------- Checking status of PHP73-PHP-FPM (is it good work with TLS/SSL configs) ---------\n"
systemctl restart php73-php-fpm
systemctl status php73-php-fpm | grep active

echo -e  "\n------- Checking status of DEFAULT PHP-FPM (is it good work with TLS/SSL configs) ---------\n"
systemctl restart php-fpm
systemctl status php-fpm | grep active


