#!/bin/sh
sudo yum -y update
sudo yum -y clean packages
sudo yum -y install epel-release
sudo yum -y install ansible
sudo usermod -aG ansible vagrant

#Provisionamento para WInRM
sudo yum -y install pip3
sudo pip3 install wheel
sudo pip3 install pywinrm

#Kerberus somente se utilizar algum AD.
#sudo pip3 install pywinrm[kerberos]


cat << EOT >> /etc/hosts
192.168.56.11	jenkins
192.168.56.12	docker
EOT