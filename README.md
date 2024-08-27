## Playground / Practice for Prometheus, Grafana, Blackbox Exporter

### Current 

run 
```bash
docker compose up
```

Will create the docker containers on the same network and ping https://www.example.com to check if it is live

[Prometheus Port](localhost:9090/targets) - Shows if Site is live  
[Blackbox Port](localhost:9115/) - Blackbox page for debug