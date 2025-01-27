#!/bin/bash

sudo ufw disable
sudo echo "192.168.56.111  mmateoSW" | sudo tee -a /etc/hosts
K3S_URL=https://192.168.56.110:6443
K3S_TOKEN=$(cat /vagrant_data/node-token)

# Esperar a que el servidor esté completamente operativo
sleep 30

curl -sfL https://get.k3s.io | K3S_URL=$K3S_URL K3S_TOKEN=$K3S_TOKEN sh -s - agent --node-ip=192.168.56.111

sudo ip link add eth1 type dummy || { echo "Failed to add eth1"; exit 1; }
sudo ip addr add 192.168.56.111/24 dev eth1 || { echo "Failed to assign IP to eth1"; exit 1; }
sudo ip link set eth1 up || { echo "Failed to bring up eth1"; exit 1; }

# Eliminar el archivo node-token
rm -f /vagrant_data/node-token