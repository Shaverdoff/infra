# NGINX
```
# check exist module
nginx -V 2>&1 | grep -o with-http_stub_status_module

add default.conf like this:
server {
    listen 80 default_server;
    charset utf-8;
    server_name _;
    location /metrics {
        stub_status on;
        access_log off;
        allow 127.0.0.1;
        allow 172.16.0.0/12;
        deny all;
    }
}

curl http://127.0.0.1/nginx_status

# install
cd /opt
wget https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v0.8.0/nginx-prometheus-exporter-0.8.0-linux-amd64.tar.gz
tar xfvz nginx-prometheus-exporter-0.8.0-linux-amd64.tar.gz

/opt/nginx-prometheus-exporter -nginx.scrape-uri http://127.0.0.1/nginx_status
mv /opt/nginx-prometheus-exporter /usr/sbin/
sudo useradd — no-create-home — shell /bin/false nginx_exporter

nano /etc/systemd/system/nginx_exporter.service
[Unit]
Description=NGINX Prometheus Exporter 
After=network.target

[Service]
Type=simple
User=nginx_exporter
Group=nginx_exporter
ExecStart=/usr/sbin/nginx-prometheus-exporter -web.listen-address=45.56.107.156:9113 -nginx.scrape-uri http://127.0.0.1/metrics
SyslogIdentifier=nginx_prometheus_exporter
Restart=always
RestartSec=3

[Install]
WantedBy=default.target


sudo systemctl daemon-reload
sudo systemctl enable nginx_exporter
sudo systemctl start nginx_exporter
sudo systemctl restart nginx_exporter
sudo systemctl status nginx_exporter
sudo firewall-cmd --permanent --zone=public --add-port=9113/tcp
sudo firewall-cmd --reload
```