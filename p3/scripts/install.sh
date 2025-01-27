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

# Function to create and verify cluster
create_cluster() {
    local cluster_name="mycluster"
    
    # Check if cluster already exists
    if k3d cluster list | grep -q "${cluster_name}"; then
        echo "Cluster '${cluster_name}' already exists"
    else
        echo "Creating cluster '${cluster_name}'..."
        if k3d cluster create "${cluster_name}"; then
            echo "Cluster created successfully"
        else
            echo "Error: Failed to create cluster"
            exit 1
        fi
    fi

    # Wait for nodes to be ready
    echo "Waiting for nodes to be ready..."
    kubectl wait --for=condition=ready nodes --all --timeout=60s

    # Display cluster information
    echo "Cluster nodes:"
    kubectl get nodes -o wide
}

# Main execution
echo "Starting cluster setup..."
install_k3d
create_cluster
# Install ArgoCD
echo "Installing ArgoCD..."
kubectl create namespace argocd || true
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD pods to be ready
echo "Waiting for ArgoCD pods to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s
echo "Setup completed successfully"