#!/bin/bash

sudo yum update -y

#1. ssh config
readonly SSH_CONFIG=~/.ssh/config
cat <<EOT >${SSH_CONFIG}
Host its
  HostName 192.168.32.12
  StrictHostKeyChecking no
Host vcs
  HostName 192.168.32.13
  StrictHostKeyChecking no
Host ci
  HostName 192.168.32.14
  StrictHostKeyChecking no
EOT

chmod 600 ${SSH_CONFIG}

#6. postfix install
sudo yum install -y postfix
sudo systemctl enable postfix
sudo systemctl start postfix



sudo yum install -y http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm
sudo yum install -y zabbix-server-mysql zabbix-web-mysql zabbix-web-japanese zabbix-agent
yum install mariadb-server
# vi /etc/my.cnf.d/server.cnf
systemctl enable mariadb
systemctl start mariadb

# mysql -uroot
# MariaDB [(none)]> create database zabbix;
# MariaDB [(none)]> grant all privileges on zabbix.* to zabbix@localhost identified by 'password' ;
# MariaDB [(none)]> exit
#
#zcat /usr/share/doc/zabbix-server-mysql-3.0.0/create.sql.gz | mysql -uroot zabbix
 vi /etc/zabbix/zabbix_server.conf
 DBPassword=password
 vi /etc/httpd/conf.d/zabbix.conf
 php_value date.timezone Asia/Tokyo
 # systemctl start zabbix-server
# systemctl start zabbix-agent
# systemctl start httpd
# systemctl enable zabbix-server
# systemctl enable zabbix-agent
# systemctl enable httpd
