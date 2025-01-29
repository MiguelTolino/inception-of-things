# Inception of Things - Part 1

Este proyecto configura un entorno de desarrollo utilizando Vagrant y VirtualBox. El entorno incluye dos máquinas virtuales: un servidor y un agente. El servidor se configura con K3s, una distribución ligera de Kubernetes, y el agente se prepara para interactuar con el servidor.


## Prerrequisitos

- Vagrant
- VirtualBox

## Componentes

### 1. Vagrantfile
El `Vagrantfile` define la configuración de las dos máquinas virtuales:
- **Servidor (`mmateoS`)**: Configurado con 2 CPUs y 2048 MB de memoria. Ejecuta el script `server.sh` para instalar y configurar K3s.
- **Agente (`mmateoSW`)**: Configurado con 1024 MB de memoria. Ejecuta el script `agent.sh`.

### 2. Script del Servidor (`server.sh`)
El script `server.sh` realiza las siguientes tareas:
- Espera a que K3s esté listo.
- Verifica la instalación de K3s.
- Aplica configuraciones de Kubernetes desde archivos YAML.

### 3. Script del Agente (`agent.sh`)
El script `agent.sh` se puede utilizar para configurar el agente.

## Uso

1. Clonar el repositorio y acceder a la carpeta:
```sh
cd inception-of-things/p1
vagrant up

vagrant ssh mmateoS
kubectl get nodes
```
