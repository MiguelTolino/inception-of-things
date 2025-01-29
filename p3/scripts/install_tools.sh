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
    # Check if kubectl is already installed
    if command -v kubectl &> /dev/null; then
        echo "kubectl is already installed"
        exit 0
    fi
    
    # Define the architecture
    ARCH="amd64"  # For most modern PCs. Use "arm64" for ARM architecture.
    
    # Download the latest release of kubectl
    echo "Downloading kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl"
    
    # Make the kubectl binary executable
    echo "Making kubectl executable..."
    chmod +x kubectl
    
    # Move the binary to a directory included in your system's PATH
    echo "Moving kubectl to /usr/local/bin/..."
    sudo mv kubectl /usr/local/bin/
    
    # Verify the installation
    echo "Verifying kubectl installation..."
    kubectl version --client
    
    echo "kubectl installation completed successfully!"
}

# Install Docker
install_docker

# Install k3d
install_k3d

# Install kubectl
install_kubectl