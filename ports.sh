#!/bin/bash

kubectl port-forward svc/prometheus-service 9090:9090 -n prom-setup-monitoring > /dev/null 2>&1 &
PROMETHEUS_PORT_FORWARD_PID=$!
kubectl port-forward svc/blackbox-exporter 9115:9115 -n prom-setup-monitoring > /dev/null 2>&1 &
BLACKBOX_PORT_FORWARD_PID=$!
kubectl port-forward svc/grafana 3000:3000 -n prom-setup-monitoring > /dev/null 2>&1 &
GRAFANA_PORT_FORWARD_PID=$!

echo "Prometheus is forwarded -> localhost:9090"
echo "Blackbox is forwarded -> locahost:9115"
echo "Grafana is forwarded -> localhost:3000"

echo "port forwarding active - ctrl+c to exit script"

cleanup() {
    echo " Stopping port forwarding"
    kill $PROMETHEUS_PORT_FORWARD_PID
    kill $BLACKBOX_PORT_FORWARD_PID
    kill $GRAFANA_PORT_FORWARD_PID
    echo "Port forwarding stopped and script exited"
}

trap cleanup EXIT

wait