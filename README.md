## Practice Setup for Prometheus, Grafana, Blackbox Exporter, kubernetes

### Current Rundown

Launches local kubernetes pods using kind, making use of - 
  - Blackbox Exporter
  - Prometheus
  - Grafana
  - mkcert

Using the blackbox and prometheus, it probes -
  - https://www.example.com
  - https://www.google.com
  - https://www.facebook.com
  
Grafana then gets the metrics onto the dashboard and displays if the sites are up/down and some connection time stuff
  
Grafana runs on a HTTPS connection using certs generated from mkcert

[localhost:9090/targets](localhost:9090/targets) - Shows if Site is live on Prometheus  
[localhost:9115](localhost:9115/) - Blackbox page for debug  
[https://localhost](https://localhost:3000) - Grafana instance on HTTPS connection

### Initial Setup

This setup is for Mac users only, havnt searched how to do it on windows/linux at all  
The setup uses Brew so make sure it is installed already
  
Install Docker
```shell
brew install --cask docker
```
  
Install kubectl
```shell
brew install kubectl
```
  
Install kind
```shell
brew install kind
```
  
Install mkcert - if you use firefox also install nss
```shell
brew install mkcert
brew install nss # Firefox users have to have this
# If you are a firefox user and have already ran 'mkcert -install', you will have to re-run it after 'brew install nss'
```
  
Setup initial mkcert certs - it will prompt for sudo password a few times
```shell
mkcert -install
```
  
make the three .sh files executable
```shell
# Make sure you are in the prom-setup directory
chmod +x deploy.sh destroy.sh ports.sh
```
  
Now that you are all setup, you can run the scripts to deploy or destroy, and also handle the port-forwarding
  
```shell
./deploy.sh # Sets up certs, creates cluster, deploys pods

./ports.sh # Enables the port-forwarding to access the endpoints

./destroy.sh # Destroys the pods and cluster
```