#!/bin/bash

# ssh config
ssh_config=~/.ssh/config
cat << EOT > $ssh_config
Host web
  HostName 192.168.43.41
  StrictHostKeyChecking no
Host app
  HostName 192.168.43.42
  StrictHostKeyChecking no
Host db1
  HostName 192.168.43.43
  StrictHostKeyChecking no
Host db2
  HostName 192.168.43.44
  StrictHostKeyChecking no
Host nosql1
  HostName 192.168.43.45
  StrictHostKeyChecking no
Host nosql2
  HostName 192.168.43.46
  StrictHostKeyChecking no
Host its
  HostName 192.168.43.51
  StrictHostKeyChecking no
Host vcs
  HostName 192.168.43.52
  StrictHostKeyChecking no
EOT

chmod 600 $ssh_config

# ssh key copy
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

# ansible install
sudo yum install -y ansible
ansible --version

# git, jenkins install
sudo yum install -y git java wget
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins
sudo chkconfig jenkins on
sudo service jenkins start
