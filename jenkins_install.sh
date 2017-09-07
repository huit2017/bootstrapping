#!/bin/bash

sudo yum update
#1. ssh config
readonly SSH_CONFIG=~/.ssh/config
cat <<EOT >${SSH_CONFIG}
Host mail
  HostName 192.168.32.11
  StrictHostKeyChecking no
Host its
  HostName 192.168.32.12
  StrictHostKeyChecking no
Host vcs
  HostName 192.168.32.13
  StrictHostKeyChecking no
EOT

chmod 600 ${SSH_CONFIG}

#2. ssh key create
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

#3. ansible install
sudo yum install -y ansible
# git install
sudo yum install -y git
# jenkins install
sudo yum install -y java wget
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins
sudo chkconfig jenkins on
sudo service jenkins start
