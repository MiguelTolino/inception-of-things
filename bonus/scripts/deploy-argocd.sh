#!/bin/bash
set -e  # Stops script in case of error

urlencode() { # Needed since we are using the kubernetes secrets to generate the pasword, handles special characters for gitlab
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "%s" "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
}

# Settings
CLUSTER_NAME="mycluster"
ARGOCD_NS="argocd"
APP_NS="dev"
GITHUB_REPO_URL="https://github.com/MiguelTolino/mmateo-t.git"
GITLAB_NS="gitlab"
GITLAB_DOMAIN="gitlab.localhost"
GITLAB_PORT=8081
GITLAB_REPO_NAME="myrepo"
GITLAB_REPO_PATH="root/${GITLAB_REPO_NAME}"
APP_NAME="myapp"
APP_PATH="manifests"
GITLAB_INTERNAL_URL="http://gitlab-webservice-default.gitlab.svc.cluster.local:8181/${GITLAB_REPO_PATH}.git"

# 0. Clone repository from GitHub
git clone $GITHUB_REPO_URL
REPO_DIR=$(basename $GITHUB_REPO_URL .git)

# 1. Create k3d cluster
k3d cluster create $CLUSTER_NAME --port "${GITLAB_PORT}:80@loadbalancer" --k3s-arg "--disable=traefik@server:0"

# Install GitLab via Helm
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
  --namespace $GITLAB_NS --create-namespace --timeout 600s \
  -f https://gitlab.com/gitlab-org/charts/gitlab/-/raw/master/examples/values-minikube-minimum.yaml \
  --set global.hosts.domain=localhost --set global.hosts.externalIP= \
  --set global.hosts.https=false --set certmanager.install=false \
  --set prometheus.install=false --set gitlab-runner.install=false \
  --set global.ingress.configureCertmanager=false --set global.ingress.class=nginx \
  --set nginx-ingress.enabled=true --set global.ingress.tls.enabled=false \
  --set 'global.ingress.annotations.nginx.ingress.kubernetes.io/ssl-redirect'=false

# Wait for GitLab
for dep in gitlab-webservice-default gitlab-sidekiq-all-in-1-v2 gitlab-toolbox; do
  kubectl wait --namespace $GITLAB_NS --for=condition=available deployment/$dep --timeout=600s
done

# Get GitLab password
GITLAB_PASSWORD=$(kubectl -n $GITLAB_NS get secret gitlab-gitlab-initial-root-password -o jsonpath="{.data.password}" | base64 -d)

# Add to /etc/hosts if needed
if ! grep -q "127.0.0.1 ${GITLAB_DOMAIN}" /etc/hosts; then
  echo "127.0.0.1 ${GITLAB_DOMAIN}" | sudo tee -a /etc/hosts
fi

# Create GitLab token
TOOLBOX_POD=$(kubectl get pods -n $GITLAB_NS -l app=toolbox -o jsonpath='{.items[0].metadata.name}')
GITLAB_TOKEN=$(kubectl exec -n $GITLAB_NS $TOOLBOX_POD -- gitlab-rails runner "user = User.find_by_username('root'); token = user.personal_access_tokens.create(scopes: [:api], name: 'automation'); puts token.token")

# Create project in GitLab
curl -H "Host: ${GITLAB_DOMAIN}" -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" -X POST "http://127.0.0.1:${GITLAB_PORT}/api/v4/projects?name=${GITLAB_REPO_NAME}&path=${GITLAB_REPO_NAME}&visibility=private"

# Push repo to GitLab
cd $REPO_DIR
GITLAB_PASSWORD_ENCODED=$(urlencode "$GITLAB_PASSWORD")
git remote add gitlab http://root:${GITLAB_PASSWORD_ENCODED}@${GITLAB_DOMAIN}:${GITLAB_PORT}/${GITLAB_REPO_PATH}.git
git push gitlab --all --force
git push gitlab --tags --force
cd ..

# 2. Install ArgoCD
kubectl create namespace $ARGOCD_NS
kubectl apply -n $ARGOCD_NS -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 3. Wait for ArgoCD
kubectl wait --namespace $ARGOCD_NS --for=condition=available deployment/argocd-server --timeout=300s

# 4. Get ArgoCD password
ARGOCD_PASSWORD=$(kubectl -n $ARGOCD_NS get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# 5. Port-forward ArgoCD
kubectl port-forward -n $ARGOCD_NS svc/argocd-server 8080:443 >/dev/null 2>&1 &
sleep 3

# 6. Login to ArgoCD
argocd login localhost:8080 --username admin --password $ARGOCD_PASSWORD --insecure

# 7. Add GitLab repo to ArgoCD
argocd repo add $GITLAB_INTERNAL_URL --username root --password $GITLAB_PASSWORD --insecure-skip-server-verification

# 8. Create dev namespace
kubectl create namespace $APP_NS

# 9. Create ArgoCD app
argocd app create $APP_NAME --repo $GITLAB_INTERNAL_URL --path "$APP_PATH" \
  --dest-server https://kubernetes.default.svc --dest-namespace $APP_NS --sync-policy automated

# 10. Sync app
argocd app sync $APP_NAME

# 11. Port-forward app
kubectl port-forward svc/my-app-service 8888:8888 -n $APP_NS >/dev/null 2>&1 &

# 12. Show info
echo -e "\n✅ Deployment completed!"
echo "ArgoCD UI: https://localhost:8080 (admin / $ARGOCD_PASSWORD)"
echo "GitLab UI: http://${GITLAB_DOMAIN}:${GITLAB_PORT} (root / $GITLAB_PASSWORD)"
echo "GitLab Repo: http://${GITLAB_DOMAIN}:${GITLAB_PORT}/${GITLAB_REPO_PATH}.git"
echo "App: http://localhost:8888"