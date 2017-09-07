#!/bin/bash

. init.sh
#1. Install and configure the necessary dependencies
sudo yum install -y postfix
sudo systemctl enable postfix
sudo systemctl start postfix
