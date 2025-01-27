#!/bin/bash

sudo ufw disable
sudo echo "192.168.56.110  mmateoS" | sudo tee -a /etc/hosts
curl -sfL https://get.k3s.io | sh -s - server --node-ip=192.168.56.110
sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant_data/node-token

sudo ip link add eth1 type dummy || { echo "Failed to add eth1"; exit 1; }
sudo ip addr add 192.168.56.110/24 dev eth1 || { echo "Failed to assign IP to eth1"; exit 1; }
sudo ip link set eth1 up || { echo "Failed to bring up eth1"; exit 1; }