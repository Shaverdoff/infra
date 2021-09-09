```
# Nginx
расскоментить блок nginx.conf в configuration.yml
nano /opt/instana/agent/etc/instana/configuration.yaml

# NGINX_STATUS METRICS add to default.conf
location /nginx_status {
  stub_status  on;
  access_log   off;
  allow 127.0.0.1; # Or the Remote IP of the Instana Host Agent
  deny  all;
}

# TRACERT
внести изменения в nginx.conf
# INSTANA
load_module modules/glibc-nginx-1.20.1-ngx_http_ot_module.so;
env INSTANA_SERVICE_NAME;
env INSTANA_AGENT_HOST;
env INSTANA_AGENT_PORT;
env INSTANA_MAX_BUFFERED_SPANS;
env INSTANA_DEV;
http {
    # INSTANA
    opentracing_load_tracer /usr/share/nginx/modules/glibc-libinstana_sensor.so /etc/instana-config.json;
    opentracing_propagate_context;
```
