# Inception of Things - Part 3

This project demonstrates the setup of a Kubernetes development environment using K3d and ArgoCD for continuous deployment. The project automates the deployment of a web application using GitOps principles.

## Project Structure

```
.
├── README.md
├── scripts/
│   ├── install_k3d.sh
│   └── deploy-argocd.sh
└── manifests/
    └── deployment.yaml
```

## Prerequisites

- Docker
- kubectl
- Linux/Unix environment

## Components

### 1. Installation Script (`install_tools.sh`)
- Automates the installation of K3d and kubectl and docker
- Performs availability checks before installation
- Ensures all necessary tools are present

### 2. Deployment Script (`deploy-argocd.sh`)
The script automates:
- K3d cluster creation
- ArgoCD installation and configuration
- Application deployment setup
- Port forwarding for access

### 3. Kubernetes Manifests (`deployment.yaml`)
Contains:
- Deployment configuration for the web application
- Service definition for internal access
- Uses image `wil42/playground:v1`
- Exposes port 8888

## Usage

1. Install required tools:
```bash
./scripts/install_k3d.sh
```

2. Deploy the application:
```bash
./scripts/deploy-argocd.sh
```

3. Access the applications:
- ArgoCD UI: https://localhost:8080
- Web Application: http://localhost:8888

## Change Application Version
To change the version of the web application, you need to update the image tag in the `deployment.yaml` file located in the `manifests/` directory. 

Open the `deployment.yaml` file and locate the line that specifies the image tag. It should look like this:

```yaml
image: wil42/playground:v1
```

Replace `v1` with the desired version of the application. For example, if you want to use version 2, the line should be:

```yaml
image: wil42/playground:v2
```

Save the changes and proceed with the deployment steps mentioned in the README.

Remember to rebuild and push the updated image to the container registry before deploying the application with the new version.


## Features

- Automated cluster setup
- GitOps-based deployment with ArgoCD
- Continuous synchronization with Git repository
- Automated port forwarding
- Secure credential management

## Notes

- The ArgoCD password is generated automatically
- All services run in isolated namespaces
- The deployment uses automated sync policy