#!/bin/bash

sudo yum update

readonly DOMAIN='192.168.32.14.com'
readonly HOSTNAME='smtp.'${DOMAIN}
readonly ROOTS_MAIL='foo@bar.com.org'
#1. Install and configure the necessary dependencies
sudo yum install -y postfix cyrus-sasl cyrus-sasl-plain
readonly ETC_ALIASES='/etc/aliases'
sudo cp ${ETC_ALIASES} ${ETC_ALIASES}.org
echo "root:          ${ROOTS_MAIL}" | sudo tee -a ${ETC_ALIASES}
#sudo /usr/bin/newaliases
/usr/sbin/alternatives --config mta
readonly MAIN_CF='/etc/postfix/main.cf'
sudo cp ${MAIN_CF} ${MAIN_CF}.org
echo "myhostname = ${HOSTNAME}" | sudo tee -a ${MAIN_CF}
echo "mydomain = ${DOMAIN}" | sudo tee -a ${MAIN_CF}
echo 'myorigin = $mydomain' | sudo tee -a ${MAIN_CF}
echo 'inet_interfaces = all' | sudo tee -a ${MAIN_CF}
echo 'mydestination = $myhostname, localhost.$mydomain, $mydomain' | sudo tee -a ${MAIN_CF}
echo 'mynetworks_style = subnet'
sudo systemctl enable postfix
sudo systemctl start postfix
