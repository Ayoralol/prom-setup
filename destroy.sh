#!/bin/bash

read -p "Are you sure you want to destroy the cluster and all contents? (y/n): " CHOICE

if [[ "$CHOICE" != "y" && "$CHOICE" != "Y" ]]; then
    echo "Aborting destroy"
    exit 1
fi

NAMESPACE=prom-setup-monitoring

kubectl delete service prometheus-service -n $NAMESPACE
kubectl delete deployment prometheus -n $NAMESPACE
kubectl delete configmap prometheus-config -n $NAMESPACE

kubectl delete service blackbox-exporter -n $NAMESPACE
kubectl delete deployment blackbox-exporter -n $NAMESPACE

kubectl delete deployment grafana -n $NAMESPACE
kubectl delete service grafana -n $NAMESPACE
kubectl delete configmap grafana-datasource -n $NAMESPACE
kubectl delete configmap grafana-dashboard-provider -n $NAMESPACE
kubectl delete configmap grafana-dashboard -n $NAMESPACE
kubectl delete configmap grafana-certificates -n $NAMESPACE
kubectl delete configmap grafana-config -n $NAMESPACE

kubectl delete deployment sloth -n $NAMESPACE
kubectl delete crd prometheusservicelevels.sloth.slok.dev

kubectl delete namespace $NAMESPACE

kind delete cluster --name prom-setup-cluster

echo "destroyed"