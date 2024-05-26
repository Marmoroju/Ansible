#!/bin/sh
sudo yum -y install epel-release
sudo yum -y install ansible

cat << EOT >> /etc/hosts
192.168.56.11	jenkins
192.168.56.12	docker
EOT