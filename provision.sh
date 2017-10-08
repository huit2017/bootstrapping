#!/bin/bash

sudo yum update -y

#1. ssh keygen
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
#2. git, ansible install
sudo yum install -y git ansible
