#!/bin/bash

echo "Esperando que K3s esté listo..."
sleep 30
until sudo k3s kubectl get node | grep -q " Ready"; do
  sleep 5
  echo "Aún esperando que K3s esté listo..."
done

# Verificar la instalación de K3s
if ! command -v kubectl &> /dev/null; then
    echo "Error: K3s no se instaló correctamente"
    exit 1
fi

# Aplicar configuraciones de Kubernetes
echo "Aplicando configuraciones de Kubernetes..."
kubectl apply -f /vagrant/k3s-configs/traefik/app-ingress.yml
kubectl apply -f /vagrant/k3s-configs/app-one/app1.yml
kubectl apply -f /vagrant/k3s-configs/app-two/app2.yml
kubectl apply -f /vagrant/k3s-configs/app-three/app3.yml

# Mostrar estado final
echo "Estado final del cluster:"
kubectl get all