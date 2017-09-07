#!/bin/bash

. init.sh

#1. Install and configure the necessary dependencies
sudo yum install -y curl policycoreutils openssh-server openssh-clients
sudo systemctl enable sshd
sudo systemctl start sshd
sudo systemctl enable httpd
sudo systemctl start httpd
sudo yum install postfix
sudo systemctl enable postfix
sudo systemctl start postfix
#sudo firewall-cmd --permanent --add-service=http

#2. Add the GitLab package server and install the package
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
sudo yum install -y gitlab-ce

#3. Configure and start GitLab
sudo gitlab-ctl reconfigure
