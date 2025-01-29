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

# Function to check and install kubectl
install_kubectl() {
    if ! command -v kubectl &> /dev/null; then
        echo "kubectl is not installed. Installing..."
        if sudo apt-get update && sudo apt-get install -y kubectl; then
            echo "kubectl has been successfully installed"
        else
            echo "Error: Failed to install kubectl"
            exit 1
        fi
    else
        echo "kubectl is already installed"
    fi
}

# Install Docker
install_docker

# Install k3d
install_k3d

# Install kubectl
install_kubectl