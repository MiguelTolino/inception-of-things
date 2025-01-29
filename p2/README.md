# Inception of Things - Part 2

Este proyecto configura un entorno de desarrollo utilizando Vagrant y K3s. El entorno incluye la configuración de un clúster de Kubernetes ligero y la implementación de varias aplicaciones.

## Prerrequisitos

- Vagrant
- VirtualBox

## Componentes

### 1. Vagrantfile
El [`Vagrantfile`]("/home/mmateo-t/42Cursus/inception-of-things/Vagrantfile") define la configuración de la máquina virtual que se utilizará para ejecutar K3s.

### 2. Scripts
- **[`server.sh`]("/home/mmateo-t/42Cursus/inception-of-things/p2/scripts/server.sh")**: Este script instala K3s en la máquina virtual y aplica configuraciones de Kubernetes desde archivos YAML.

### 3. Configuraciones de K3s
El directorio `k3s-configs` contiene las configuraciones de Kubernetes para varias aplicaciones:
- **`app-one`**: Contiene la configuración para la primera aplicación (`app1.yml`).
- **`app-two`**: Contiene la configuración para la segunda aplicación (`app2.yml`).
- **`app-three`**: Contiene la configuración para la tercera aplicación (`app3.yml`).
- **`traefik`**: Contiene la configuración de Traefik ([`app-ingress.yml`])

## Estructura de Carpetas
```
p2/
├── .vagrant/
├── k3s-configs/
│   ├── app-one/
│   │   └── app1.yml
│   ├── app-three/
│   │   └── app3.yml
│   ├── app-two/
│   │   └── app2.yml
│   └── traefik/
│       └── app-ingress.yml
├── scripts/
│   └── server.sh
├── Vagrantfile
└── README.md
```

## Descripción de los Scripts

### `server.sh`
Este script realiza las siguientes tareas:
- Instala K3s en la máquina virtual.
- Espera a que K3s esté listo.
- Verifica la instalación de K3s.
- Aplica configuraciones de Kubernetes desde los archivos YAML ubicados en el directorio `/vagrant/k3s-configs`.
- Muestra el estado final del clúster.

## Uso

1. Acceder a la carpeta:
```sh
cd inception-of-things/p2
```

2. Levantar la máquina virtual con Vagrant:
```sh
vagrant up
```

3. Accede a las distintas apps a través de HTTP
```sh
curl app1.com 
curl app2.com 
curl app3.com
curl 192.168.56.110 
```
