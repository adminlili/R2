#!/bin/bash

cmd_START='systemctl start '
cmd_RESTART='systemctl restart '
cmd_STOP='systemctl stop '
cmd_STATUS='systemctl status '
cmd_ENABLE='systemctl enable '

PASS_mysql='123L45p68'

yum -y install wget expect


#rpm -Uvh https://repo.mysql.com/mysql80-community-release-el8.rpm
#sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/mysql-community.repo
#yum --enablerepo=mysql80-community install -y mysql-community-server

#rpm -i mysql57-community-release-el7.rpm
rpm -ev mysql-community-common-5.7.32-1.el7.x86_64
rpm -ev mysql57-community-release-el7-11.noarch

yum clean packages

#yum module disable mysql
#yum repolist all | grep mysql
# rpm -qa | grep mysql 

yum-config-manager  --disable mysql80-community
yum-config-manager  --disable mysql57-community
yum-config-manager  --disable mysql56-community
dnf config-manager  --disable mysql80-community
dnf config-manager  --disable mysql57-community
dnf config-manager  --disable mysql56-community
#dnf config-manager  --enable mysql57-community
#yum-config-manager  --enable mysql57-community

yum update -y
yum makecache -y

dnf repolist
yum repolist

echo -e  "\n--STEP 1------------------------ disable SELINUX  ---------------------------------\n"

sed 's/SELINUX="permissive"|"enforcing"|"disabled"/SELINUX=disabled/' /etc/selinux/config

setenforce 0

systemctl stop firewalld
#---------------------------------------------------
# on first install
#sed -i 's/[mysqld]\n/skip-grant-tables/g' /etc/my.cnf

chmod +x mysql_secure.sh
./mysql_secure.sh

#echo -e  'FLUSH PRIVILEGES;' | mysql -uroot -p$PASS_mysql
#echo -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '123L45p68';" | mysql -uroot -p$PASS_mysql

#sed -i 's/#?skip-grant-tables/#skip-grant-tables/' /etc/my.cnf
#$cmd_RESTART mysqld

#yum install -y mysql-community-server

yum install -y MariaDB-server

$cmd_STOP mariadb
rm -rf /var/lib/mysql/*
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
$cmd_START mariadb

$cmd_ENABLE mariadb
$cmd_STATUS mariadb | grep active


NGINX_USER=nginx_user

adduser $NGINX_USER -m -s /bin/bash -p$PASS_mysql

#echo -e "$PASS_mysql\n$PASS_mysql\n" | mysqladmin -uroot password
echo -e  "source www_sql1.sql;" | mysql -uroot -p$PASS_mysql

$cmd_ENABLE mysqld
$cmd_START mysqld
$cmd_STATUS mysqld | grep active

echo -e "--STEP 5----------------- Let's install the module pam_sql -------------------------\n"

what_centos=$(cat /etc/centos-release | awk '{print $4}' | grep '7.')
if [ '$what_centos' == '7.*' ];
then
rpm -Uvh ftp://ftp.pbone.net/mirror/archive.fedoraproject.org/fedora/linux/releases/20/Everything/x86_64/os/Packages/p/pam_mysql-0.7-0.16.rc1.fc20.x86_64.rpm
fi

echo "session optional pam_keyinit.so force revoke
auth required pam_mysql.so user=nginx_user passwd=$PASS_mysql host=localhost db=nginx_users table=users usercolumn=username passwordcolumn=password crypt=3
account required pam_mysql.so user=nginx_user passwd=$PASS_mysql host=localhost db=nginx_users table=users usercolumn=username passwordcolumn=password crypt=3
" > /etc/pam.d/nginx

$cmd_RESTART nginx
$cmd_RESTART mysqld
$cmd_STATUS mysqld | grep active


echo -e "\n------------- TESTING: Have the root account access to MariaDB/Mysql -------------\n"
echo -e  'show databases;' | mysql -uroot -p$PASS_mysql

if [ $? -eq 0 ]
then
    echo -e  "\n\t\tGreat!!! user ROOT have access to database.\n"
fi


echo -e "\n--------- TESTING: Have the NGINX_USER account access to MariaDB/Mysql ------------\n"
echo -e  'show databases;' | mysql -unginx_user -p$PASS_mysql

if [ $? -eq 0 ]
then
    echo -e  "\n\tGreat!!! user nginx_user have access to database nginx_test and nginx_users;\n"
fi

echo -e "\n---------- Congratilations!!! Configuration of mariadb service ended! -------------\n"
