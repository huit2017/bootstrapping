#!/bin/bash

readonly DB_ROOT_PASSWORD=zabbix
readonly DB_ZABBIX_PASSWORD=zabbix
sudo yum update -y

#1. ssh config
readonly SSH_CONFIG=~/.ssh/config
cat <<EOT >${SSH_CONFIG}
#Host xx
#  HostName xxx.xxx.xxx.xxx
#  StrictHostKeyChecking no
EOT

chmod 600 ${SSH_CONFIG}

#2. ssh key create
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

#3. postfix install
sudo yum install -y postfix
sudo systemctl enable postfix
sudo systemctl start postfix

#4. zabbix install
sudo rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-1.el7.centos.noarch.rpm
sudo yum install -y zabbix-server-mysql zabbix-web-mysql zabbix-agent zabbix-web-japanese
# sudo yum install zabbix-proxy-mysql # proxy

#5. MySQL install
sudo yum localinstall -y http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
sudo yum -y install mysql-community-server
sudo systemctl enable mysqld.service
sudo systemctl start mysqld.service
temporary_password=`grep "temporary password" /var/log/mysqld.log | awk '{print $11}'`
mysql -u root -p"${temporary_password}" --connect-expired-password -e "SET GLOBAL validate_password_length=4;"
mysql -u root -p"${temporary_password}" --connect-expired-password -e "SET GLOBAL validate_password_policy=LOW;"
mysql -u root -p"${temporary_password}" --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"
cat <<EOT | sudo tee /root/.my.cnf
[client]
user = root
password = ${DB_ROOT_PASSWORD}
EOT
mysql -u root -p"${DB_ROOT_PASSWORD}" -e "CREATE DATABASE zabbix character set utf8 collate utf8_bin;"
mysql -u root -p"${DB_ROOT_PASSWORD}" -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY '${DB_ZABBIX_PASSWORD}';"
mysql -u root -p"${DB_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost'"

sudo zcat `ls /usr/share/doc/zabbix-server-mysql-*/create.sql.gz` | mysql -uzabbix -p${DB_ZABBIX_PASSWORD} zabbix
# sudo zcat `ls /usr/share/doc/zabbix-proxy-mysql-*/schema.sql.gz` | mysql -uzabbix -p zabbix # proxy
sudo rpm -q zabbix-server-mysql
# sudo rpm -q zabbix-proxy-mysql # proxy

readonly ZABBIX_SERVER_CONF=/etc/zabbix/zabbix_server.conf
sudo cp ${ZABBIX_SERVER_CONF} ${ZABBIX_SERVER_CONF}.org
sudo sed -i 's/# DBPassword=/DBPassword=zabbix/' ${ZABBIX_SERVER_CONF}

#readonly ZABBIX_PROXY_CONF=/etc/zabbix/zabbix_proxy.conf
#sudo cp ${ZABBIX_PROXY_CONF} ${ZABBIX_PROXY_CONF}.org
#sudo sed -i 's/# DBPassword=/DBPassword=zabbix/' ${ZABBIX_PROXY_CONF}
#sudo systemctl enable zabbix-proxy
#sudo ystemctl start zabbix-proxy

readonly ZABBIX_CONF=/etc/httpd/conf.d/zabbix.conf
sudo cp ${ZABBIX_CONF} ${ZABBIX_CONF}.org
sudo sed -i 's@        # php_value date.timezone Europe/Riga@        php_value date.timezone Asia/Tokyo@' ${ZABBIX_CONF}

sudo setsebool -P httpd_can_connect_zabbix on
sudo setsebool -P httpd_can_network_connect_db on

#6. start zabbix
sudo systemctl enable zabbix-server
sudo systemctl enable zabbix-agent
sudo systemctl enable httpd
sudo systemctl start zabbix-server
sudo systemctl start zabbix-agent
sudo systemctl start httpd
