# Inception of Things

This project demonstrates the setup of a Kubernetes development environment using K3d and ArgoCD for continuous deployment. The project automates the deployment of a web application using GitOps principles.

## 🚀 Installation
```sh
# Clone the repository
git clone https://github.com/your-username/inception-of-things.git

# Navigate to the project directory
cd inception-of-things
```

## 📂 Folder Structure
```
inception-of-things/
├── p1/
│   ├── scripts/
│   │   ├── agent.sh
│   │   └── server.sh
│   └── Vagrantfile
├── p2/
│   ├── k3s-configs/
│   │   ├── app-one/
│   │   ├── app-three/
│   │   ├── app-two/
│   │   └── traefik/
│   ├── scripts/
│   │   └── server.sh
│   └── Vagrantfile
├── p3/
│   ├── mmateo-t/
│   ├── scripts/
│   │   ├── deploy-argocd.sh
│   │   └── install_k3d.sh
│   ├── manifests/
│   │   └── deployment.yaml
│   └── README.md
├── .gitignore
├── Vagrantfile
└── README.md
```

# READMEs

## [p1/ README](./p1/README.md)
This folder contains the scripts and Vagrantfile for the first part of the project.

## [p2/ README](./p2/README.md)
This folder contains the k3s-configs, scripts, and Vagrantfile for the second part of the project.

## [p3/ README](./p3/README.md)
This folder contains the mmateo-t folder, scripts, manifests, and README.md for the third part of the project.



## 🤝 Contributing
1. Fork the repository
2. Create a new branch (`feature/your-feature`)
3. Commit your changes (`git commit -m 'Add new feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Create a Pull Request

## 📝 License
This project is licensed under the [MIT License](LICENSE).
