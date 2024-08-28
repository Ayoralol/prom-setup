## Playground / Practice for Prometheus, Grafana, Blackbox Exporter, nginx

### Current 

run 
```bash
docker compose up -d
```

Creates docker containers for 
  - blackbox
  - prometheus
  - grafana
  - nginx
  - certgen

blackbox + prometheus probes 
  - https://www.example.com
  - https://www.google.com
  - https://www.facebook.com

Grafana then gets the data onto the dashboard and displays if the sites are up/down and some connection time metrics  
  
nginx lets grafana run on HTTPS connection with cergen certificates/keys  
  
WILL WARN YOU WHEN CONNECTING TO GRAFANA  
  
Just ignore the warning and connect (as it is trusted since its just this instance)  

[localhost:9090/targets](localhost:9090/targets) - Shows if Site is live on Prometheus  
[localhost:9115](localhost:9115/) - Blackbox page for debug  
[https://localhost](https://localhost) - Grafana instance on HTTPS connection
