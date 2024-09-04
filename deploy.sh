#!/bin/bash

CERT_DIR="kubernetes/grafana/certs"
CERT_KEY="$CERT_DIR/grafana.key"
CERT_PEM="$CERT_DIR/grafana.pem"

mkdir -p $CERT_DIR

if [ ! -f "$CERT_KEY" ] || [ ! -f "$CERT_PEM" ]; then
    echo "Generating SSL certificate for localhost..."
    mkcert -key-file "$CERT_KEY" -cert-file "$CERT_PEM" localhost
fi

echo "SSL certificates are ready"

kind create cluster --name prom-setup-cluster --config kind-config.yml

kubectl create namespace prom-setup-monitoring

kubectl create configmap prometheus-config --from-file=kubernetes/prometheus/prometheus.yml --namespace=prom-setup-monitoring

kubectl apply -f kubernetes/prometheus/prometheus-deployment.yml
kubectl apply -f kubernetes/prometheus/prometheus-service.yml
kubectl apply -f kubernetes/blackbox/blackbox-deployment.yml
kubectl apply -f kubernetes/blackbox/blackbox-service.yml

kubectl create configmap grafana-certificates --from-file=cert.pem=$CERT_PEM --from-file=cert.key=$CERT_KEY -n prom-setup-monitoring

kubectl apply -f kubernetes/grafana/grafana-configmap.yml
kubectl apply -f kubernetes/grafana/grafana-datasource.yml
kubectl apply -f kubernetes/grafana/grafana-dashboard.yml
kubectl apply -f kubernetes/grafana/grafana-dashboard-provider.yml
kubectl apply -f kubernetes/grafana/grafana-deployment.yml
kubectl apply -f kubernetes/grafana/grafana-service.yml

echo "Waiting for all pods to be ready..."

kubectl wait --for=condition=Ready pods --all -n prom-setup-monitoring --timeout=300s

if [ $? -eq 0 ]; then
  echo "All pods are Running. Run ./ports.sh to activate port forwarding"
else
  echo "Timed out waiting for pods to be ready."
  exit 1
fi