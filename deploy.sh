#!/bin/bash

check_install() {
  if ! command -v "$1" &> /dev/null
  then
    echo "Error: $1 is not installed"
    exit 1
  fi
}

check_helm_repo() {
  local repo_name="$1"
  local repo_url="$2"

  # Check if the repository is already added
  if helm repo list | grep -q "^$repo_name"; then
    echo "Helm repository '$repo_name' is already added."
  else
    echo "Adding Helm repository '$repo_name'..."
    helm repo add "$repo_name" "$repo_url"
    if [ $? -ne 0 ]; then
      echo "Error: Failed to add Helm repository '$repo_name'."
      exit 1
    fi
  fi
}

echo "Checking required tools"

check_install docker
check_install kubectl
check_install kind
check_install mkcert
check_install nss
check_install helm

echo "Checking required helm repo's"

check_helm_repo prometheus_community https://prometheus-community.github.io/helm-charts
check_helm_repo sloth https://slok.github.io/sloth

echo "Tools and repo's present"

CERT_DIR="grafana/certs"
CERT_KEY="$CERT_DIR/grafana.key"
CERT_PEM="$CERT_DIR/grafana.pem"

mkdir -p $CERT_DIR

echo "Checking SSL Certificates"
if [ ! -f "$CERT_KEY" ] || [ ! -f "$CERT_PEM" ]; then
    echo "Generating SSL certificate for localhost"
    mkcert -key-file "$CERT_KEY" -cert-file "$CERT_PEM" localhost
fi
echo "SSL certificates are ready"

helm repo update prometheus-community
helm repo update sloth

kind create cluster --name prom-setup-cluster --config kind-config.yml

kubectl create namespace prom-setup-monitoring

helm install prometheus-operator prometheus-community/kube-prometheus-stack --namespace prom-setup-monitoring
helm install sloth sloth/sloth --namespace prom-setup-monitoring

kubectl create configmap prometheus-config --from-file=prometheus/prometheus.yml --namespace=prom-setup-monitoring

kubectl apply -f prometheus/prometheus-deployment.yml
kubectl apply -f prometheus/prometheus-service.yml
kubectl apply -f blackbox/blackbox-deployment.yml
kubectl apply -f blackbox/blackbox-service.yml

kubectl create configmap grafana-certificates --from-file=cert.pem=$CERT_PEM --from-file=cert.key=$CERT_KEY -n prom-setup-monitoring

kubectl apply -f grafana/grafana-configmap.yml
kubectl apply -f grafana/grafana-datasource.yml
kubectl apply -f grafana/grafana-dashboard.yml
kubectl apply -f grafana/grafana-dashboard-provider.yml
kubectl apply -f grafana/grafana-deployment.yml
kubectl apply -f grafana/grafana-service.yml

kubectl apply -f sloth/sloth.yml

echo "Waiting for all pods to be ready..."

kubectl wait --for=condition=Ready pods --all -n prom-setup-monitoring --timeout=300s

if [ $? -eq 0 ]; then
  echo "All pods are Running. Run ./ports.sh to activate port forwarding"
else
  echo "Timed out waiting for pods to be ready."
  exit 1
fi