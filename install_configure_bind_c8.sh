#!/bin/bash

echo -e "\t\tHello!! This script will install and configure bind/DNS service by itself :)"
echo -e "\n\n--STEP 1----------------- Install bind DNS on CentOS 8  ------------------\n\n"

touch /etc/hostname
echo -e "maindnssrv.lixhm.local" > /etc/hostname

yum install -y bind bind-utils make

echo -e "\n\n--STEP 2-------------- Configure bind DNS server on CentOS 8  -------------\n\n"

echo -e "--STEP 2.1 ---- Doing backup of start config.\n"
echo -e "--STEP 2.2 ---- Coping local pattern DNS config[named.conf] as real config for BIND service.\n"

cp /etc/named.conf "/etc/named.conf_$(date +%H_%M_%S__%d_%m_%Y).bak"
cp named.conf /etc/named.conf

echo -e "\n\n--STEP 3----------- Create a forward and reverse DNS zones files  ------------\n\n"

cp -r var_named/* /var/named/

chown -R named:named /var/named
#chown -R named:named /var/named/lixhm.local.forward
#chown -R named:named /var/named/lixhm.local.reverse

cp /etc/resolv.conf "/etc/resolv.conf_$(date +%H_%M_%S__%d_%m_%Y).bak"

# Examples:
#touch "file.conf_$(date +%F).bak
#touch "file.conf_$(date +%I_%M_%S_%p_____%e_%h_%Y).bak"
#touch "file.conf_$(date +%H_%M_%S__%d_%m_%Y).bak"

echo -e "nameserver 192.168.0.207\nnameserver 192.168.0.1" > /etc/resolv.conf

systemctl start named
systemctl enable named

named-checkconf
named-checkzone lixhm.local /var/named/lixhm.local.forward
named-checkzone 192.168.0.207 /var/named/lixhm.local.reverse

systemctl stop firewalld
systemctl restart named

echo -e "\n" && systemctl status named | grep active

<<'###BLOCK-COMMENT'
nslookup maindnssrv.lixhm.local
nslookup www.lixhm.local
nslookup ftp.lixhm.local
nslookup mail1.lixhm.local
nslookup 192.168.0.207
###BLOCK-COMMENT

echo -e "\n\n--STEP 4--------  Change a dns-server ip in interface configs.  ------------\n\n"

FILE_for_change_DNSIP=$(ls -l /etc/sysconfig/network-scripts/ifcfg-* | awk '{print $9;}')

for file in  $FILE_for_change_DNSIP
do
echo -e " -- FILE --------** $file **----------------"
sed  -i 's/DNS1=\"\?.*\"\?/DNS1="192.168.0.1"/g' $file
sed  -i 's/DNS2=\"\?.*\"\?/DNS2="127.0.0.1"/g' $file
done

systemctl restart NetworkManager

echo -e "\n\n--STEP 5----------- Configuration of BIND/DNS service HAS FINISHED!  ------------\n\n"
echo -e "\n**************************  RESULT  **************************************\n"

echo -e " \n\n-----* CHECK 1 *----- Checking interface configs files -------- \n\n"

cat /etc/sysconfig/network-scripts/ifcfg* | grep DNS

echo -e " \n\n-----* CHECK 2 *----- Checking status of Network Manager -------- \n\n"

systemctl status NetworkManager | grep active

echo -e " \n\n-----* CHECK 3 *----- Checking status of named service --------- \n\n"

systemctl status named | grep active

echo -e " \n\n-----* CHECK 4 *----- Checking resolving records  of DNS service -------- \n\n"

echo -e "--------- nslookup maindnssrv.lixhm.local ---------------\n"
nslookup maindnssrv.lixhm.local
echo -e "\n--------- nslookup www.lixhm.local ---------------\b"
nslookup www.lixhm.local
echo -e "\n--------- nslookup ftp.lixhm.local ---------------\n"
nslookup ftp.lixhm.local
echo -e "\n--------- nslookup mail1.lixhm.local ---------------\n"
nslookup mail1.lixhm.local
echo -e "\n--------- nslookup 192.168.0.207 ---------------\n"
nslookup 192.168.0.207
echo -e "\n--------- nslookup 127.0.0.1 ---------------\n"
nslookup 127.0.0.1
