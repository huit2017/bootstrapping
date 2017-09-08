#!/bin/bash

sudo yum update
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

#3. ansible install
sudo yum install -y ansible
#4. git install
sudo yum install -y git
#5. jenkins install
sudo yum install -y java wget
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins
sudo chkconfig jenkins on
sudo service jenkins start

#6. postfix install
sudo yum install -y postfix
sudo systemctl enable postfix
sudo systemctl start postfix
