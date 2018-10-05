#!/bin/bash

cp -f /vagrant/tests/vagrant/sshd_config /etc/ssh/sshd_config

echo "configure vagrant user"
cp /vagrant/tests/vagrant/id_rsa /home/vagrant/.ssh
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/id_rsa

systemctl restart sshd
systemctl restart network