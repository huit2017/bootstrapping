#!/bin/bash

sudo yum update -y
# manager install
sudo yum install -y java-1.8.0-openjdk rsyslog vim-common unzip java-1.8.0-openjdk-devel net-snmp-utils net-tools sysstat tcpdump lsof sblim-wbemcli wsmancli
sudo rpm -ivh https://github.com/hinemos/hinemos/releases/download/v6.0.1/hinemos-6.0-manager-6.0.1-1.el7.x86_64.rpm
# web client install
sudo yum install -y vlgothic-p-fonts
sudo rpm -ivh https://github.com/hinemos/hinemos/releases/download/v6.0.1/hinemos-6.0-web-6.0.1-1.el7.x86_64.rpm
# agent install
sudo yum install -y net-snmp net-snmp-libs tog-pegasus sblim-wbemcli sblim-cmpi-base sblim-cmpi-fsvol openlmi-storage
sudo rpm -ivh https://github.com/hinemos/hinemos/releases/download/v6.0.1/hinemos-6.0-agent-6.0.1-1.el.noarch.rpm

sudo service hinemos_manager start
sudo systemctl list-unit-files | grep hinemos
sudo service hinemos_web start
sudo service hinemos_agent start
