#!/bin/bash

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
sudo -u jenkins ssh-keygen -t rsa -N "" -f /var/lib/jenkins/.ssh/id_rsa

#6. postfix install
sudo yum install -y postfix
sudo systemctl enable postfix
sudo systemctl start postfix

### jenkins broser
# Jenkins > 設定 # Jenkinsの位置 - システム管理者のメールアドレス: Jenkis Admin <jenkins_admin@xxx.xx.xx>
# jenkins > プラグインマネージャー # インストール [Git plugin, Cobertura Plugin, FindBugs Plug-in, Checkstyle Plug-in, Pull Request Builder Plugin, SSH Slaves plugin, Docker Plugin]

### create slave
# jenkins 秘密鍵設定
# Jenkins > 設定 # クラウド - 追加 Docker

## jenkin cp public key
# sudo -u jenkins scp /var/lib/jenkins/.ssh/id_rsa.pub jenkins@192.168.32.15:/var/lib/jenkins/.ssh
# sudo -u jenkins ssh-copy-id 192.168.32.15
## Jeinkins > auth > System > Globaldomain
# scope global
# secretkey ~/.ssh
## node settings
# node name: slave1
# remote fs root: /var/lib/jenkins
# label:
# boot method: ssh [host: 192.168.32.15, auth: jenkins, Host key verification Strategy: Manually trusted...]
# avlity: keep this agent...
