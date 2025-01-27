#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

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

# install kubectl check is installed
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

# install k3d
install_k3d

# install kubectl
install_kubectl