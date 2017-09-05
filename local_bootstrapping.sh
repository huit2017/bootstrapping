#!/bin/bash

# ssh key create
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

# ansible install
sudo yum install -y ansible
# git install
sudo yum install -y git

echo '==================================================='
echo 'git config --global user.email "you@example.com"'
echo 'git config --global user.name "Your Name"'
echo 'git@github.com:huit2017/configuration.git'
echo 'ansible-playbook -i local site.yml'
echo '==================================================='
