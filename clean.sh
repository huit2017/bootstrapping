#!/bin/sh

# SELinux
setenforce 0
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

# firewalldの無効化
systemctl stop firewalld
systemctl disable firewalld

# vagrantユーザーの設定
mkdir /home/vagrant/.ssh
chown vagrant:vagrant /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ==" > /home/vagrant/.ssh/authorized_keys
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys

# 共有ホルダ
yum -y install epel-release
# yum -y install -y bzip2 gcc make kernel-devel-`uname -r` dkms gcc-c+
mount -r /dev/cdrom /mnt
/mnt/VBoxLinuxAdditions.run

# ディスク軽量化
umount /mnt
rm /root/.bash_history
yum clean all
rm -fr /var/log/*
rm -fr /tmp/*
dd if=/dev/zero of=/0 bs=4k
rm -f /0
history -c
