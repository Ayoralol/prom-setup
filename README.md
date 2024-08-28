## Playground / Practice for Prometheus, Grafana, Blackbox Exporter

### Current 

run 
```bash
docker compose up -d
```

Will create the docker containers on the same network and ping https://www.example.com to check if it is live

[localhost:9090/targets](localhost:9090/targets) - Shows if Site is live on Prometheus  
[localhost:9115](localhost:9115/) - Blackbox page for debug  
[localhost:3000](localhost:3000) - Grafana instance for dashboard access
