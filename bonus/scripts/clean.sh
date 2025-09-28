#!/bin/bash
set -e

CLUSTER_NAME="mycluster"
ARGOCD_NS="argocd"
APP_NS="dev"
GITLAB_NS="gitlab"
REPO_DIR="mmateo-t"

argocd app delete myapp --cascade --yes || true
kubectl delete namespace $ARGOCD_NS --ignore-not-found || true
kubectl delete namespace $APP_NS --ignore-not-found || true
kubectl delete namespace $GITLAB_NS --ignore-not-found || true
k3d cluster delete $CLUSTER_NAME || true
rm -rf $REPO_DIR || true
sudo sed -i "/gitlab.localhost/d" /etc/hosts || true