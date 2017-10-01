#!/bin/bash

sudo yum update -y

#1. docker install & start
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce
sudo systemctl enable docker
sudo systemctl start docker

sudo docker pull centos
sudo mkdir -p /etc/systemd/system/docker.service.d
cat <<EOT | sudo tee /etc/systemd/system/docker.service.d/docker.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock
EOT
sudo systemctl daemon-reload
sudo systemctl restart docker

image_name='sample'
mkdir ${image_name};
cat <<EOT | sudo tee ${image_name}/Dockerfile
FROM centos

RUN yum update -y
RUN yum install -y wget java openssh-server

RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
RUN ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa
RUN ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519

RUN groupadd jenkins && useradd -d /var/lib/jenkins -g jenkins -m jenkins
RUN mkdir /var/lib/jenkins/.ssh
COPY id_rsa.pub /var/lib/jenkins/.ssh/authorized_keys
RUN chown -R jenkins:jenkins /var/lib/jenkins/.ssh  && chmod 700 /var/lib/jenkins/.ssh  && chmod 600 /var/lib/jenkins/.ssh/*

RUN wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
RUN yum -y install apache-maven

#RUN yum install -y epel-release python-pip pip
#RUN pip2.7 install fabric
#RUN pip2.7 install fabric

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
EOT

#sudo mv id_rsa.pub ${image_name}/
#sudo docker build -t jenkins/${image_name}:1.0 ${image_name}
#sudo docker run -d --name java8-maven jenkins/${image_name}:1.0

## Jenkins > 設定 # クラウド - 追加 Docker
# node name: slave1
# Docker URL: tcp://192.168.32.15:2375
# push [Test Connection]
# Images - Add Docker Template
# Docker: iamge jenkins/sample:1.0
# Remote Filing System Root	: /var/lib/jenkins
# Labels: java8-maven
# Launch method: Docker SSH computer launcher
# 認証情報: jenkins
# Host Key Verification Strategy: Manually trusted key Verification Strategy
# Pull strategy: Never pull
