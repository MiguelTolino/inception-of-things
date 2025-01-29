#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to check and install Docker
install_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed. Installing..."
        if wget -q -O - https://get.docker.com/ | bash; then
            echo "Docker has been successfully installed"
            sudo usermod -aG docker $USER
            newgrp docker
        else
            echo "Error: Failed to install Docker"
            exit 1
        fi
    else
        echo "Docker is already installed"
    fi
}

# Function to check and install k3d
install_k3d() {
    if ! command -v k3d &> /dev/null; then
        echo "k3d is not installed. Installing..."
        if wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash; then
            echo "k3d has been successfully installed"
        else
            echo "Error: Failed to install k3d"
            exit 1
        fi
    else
        echo "k3d is already installed"
    fi
}

# Function to install kubectl on Ubuntu
install_kubectl() {
    echo "Updating package list..."
    sudo apt update
    
    echo "Installing required packages..."
    sudo apt install -y apt-transport-https ca-certificates curl
    
    echo "Downloading Google Cloud public signing key..."
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    
    echo "Adding Kubernetes APT repository..."
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    
    echo "Updating package list again..."
    sudo apt update
    
    echo "Installing kubectl..."
    sudo apt install -y kubectl
    
    echo "Verifying installation..."
    kubectl version --client
    
    echo "kubectl installation completed successfully!"
}

# Install Docker
install_docker

# Install k3d
install_k3d

# Install kubectl
install_kubectl