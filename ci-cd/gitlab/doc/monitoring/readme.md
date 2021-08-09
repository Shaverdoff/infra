# Monitoring with External Prometheus
```
nano gitlab.rb
prometheus['enable'] = false
node_exporter['listen_address'] = '0.0.0.0:9100'
gitlab_workhorse['prometheus_listen_addr'] = "0.0.0.0:9229"
# Rails nodes
gitlab_exporter['listen_address'] = '0.0.0.0'
gitlab_exporter['listen_port'] = '9168'
# Sidekiq nodes
sidekiq['listen_address'] = '0.0.0.0'
# Redis nodes
redis_exporter['listen_address'] = '0.0.0.0:9121'
# PostgreSQL nodes
postgres_exporter['listen_address'] = '0.0.0.0:9187'
# Gitaly nodes
gitaly['prometheus_listen_addr'] = "0.0.0.0:9236"

# NGINX monitoring
nginx['status']['options'] = {
      "server_tokens" => "off",
      "access_log" => "off",
      "allow" => "10.3.3.222",
      "deny" => "all",
}
# add prometheus ip to whitelist
gitlab_rails['monitoring_whitelist'] = ['127.0.0.0/8', '::1/128', '10.3.3.222']
# addd prometheus ip
gitlab_rails['prometheus_address'] = '10.3.3.222:9090'
```
