#!/bin/bash
set -e  # Detener el script ante cualquier error

# Configuración
CLUSTER_NAME="mycluster"
ARGOCD_NS="argocd"
APP_NS="dev"
REPO_URL="https://github.com/MiguelTolino/mmateo-t.git"
APP_NAME="myapp"
APP_PATH="./manifests"  # Cambiar si tus manifests están en otra ruta

# 0. Clone repository
git clone $REPO_URL

# 1. Crear cluster K3d
echo "🛠️  Creando cluster K3d..."
k3d cluster create $CLUSTER_NAME

# 2. Instalar ArgoCD
echo "🚀 Instalando ArgoCD..."
kubectl create namespace $ARGOCD_NS --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n $ARGOCD_NS -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 3. Esperar a que los pods estén listos
echo "⏳ Esperando a que ArgoCD esté listo..."
kubectl wait --namespace $ARGOCD_NS \
  --for=condition=available \
  deployment/argocd-server \
  --timeout=300s

# 4. Obtener contraseña
ARGOCD_PASSWORD=$(kubectl -n $ARGOCD_NS get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# 5. Port-forward en segundo plano
echo "🔌 Estableciendo port-forward..."
kubectl port-forward -n $ARGOCD_NS svc/argocd-server 8080:443 >/dev/null 2>&1 &
PORT_FORWARD_PID=$!
sleep 3  # Esperar breve para que el port-forward se establezca

# 6. Instalar CLI ArgoCD
echo "📥 Instalando ArgoCD CLI..."
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x argocd-linux-amd64
sudo mv argocd-linux-amd64 /usr/local/bin/argocd

# 7. Login en ArgoCD
echo "🔑 Iniciando sesión en ArgoCD..."
argocd login localhost:8080 \
  --username admin \
  --password $ARGOCD_PASSWORD \
  --insecure  # Necesario por el port-forward sin TLS

# 8. Crear namespace 'dev'
echo "📦 Creando namespace $APP_NS..."
kubectl create namespace $APP_NS --dry-run=client -o yaml | kubectl apply -f -

# 9. Crear aplicación
echo "⚡ Creando aplicación ArgoCD..."
argocd app create $APP_NAME \
  --repo $REPO_URL \
  --path "$APP_PATH" \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace $APP_NS \
  --sync-policy automated

# 10. Sincronizar aplicación
echo "🔄 Sincronizando aplicación..."
argocd app sync $APP_NAME

# 11. Port-forward de la aplicación
kubectl port-forward svc/my-app-service 8888:8888 -n $APP_NS >/dev/null 2>&1 &

# 11. Mostrar información
echo -e "\n✅ ¡Despliegue completado!"
echo "======================================"
echo "ArgoCD UI: https://localhost:8080"
echo "Usuario: admin"
echo "Contraseña: $ARGOCD_PASSWORD"
echo "Namespace de la aplicación: $APP_NS"
echo "Repositorio: $REPO_URL"
echo "======================================"

# Limpieza final
# kill $PORT_FORWARD_PID