#!/bin/bash

kind create cluster --name prom-setup-cluster --config kind-config.yml

kubectl create namespace prom-setup-monitoring

kubectl create configmap prometheus-config --from-file=kubernetes/prometheus/prometheus.yml --namespace=prom-setup-monitoring

kubectl apply -f kubernetes/prometheus/prometheus-deployment.yml
kubectl apply -f kubernetes/prometheus/prometheus-service.yml
kubectl apply -f kubernetes/blackbox/blackbox-deployment.yml
kubectl apply -f kubernetes/blackbox/blackbox-service.yml

echo "Waiting for pods to be in Running state..."
SECONDS_WAITED=0
while [[ $(kubectl get pods -n prom-setup-monitoring -o jsonpath='{.items[*].status.phase}') != *"Running"* ]]; do
  echo "Waiting for pods to be ready... ${SECONDS_WAITED}s"
  sleep 5
  SECONDS_WAITED=$((SECONDS_WAITED + 5))
done

echo "All pods are Running after ${SECONDS_WAITED} seconds. Run ./ports.sh to activate port forwarding"