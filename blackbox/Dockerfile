FROM prom/blackbox-exporter:latest

COPY blackbox.yml /etc/blackbox_exporter/config.yml

CMD [ "--config.file=/etc/blackbox_exporter/config.yml" ]