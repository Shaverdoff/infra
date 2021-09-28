# Source Prometheus
```
# how check it
k8sprom.company.ru/federate
```

# Main Prometheus
```
scrape_configs:
  - job_name: 'federate'
    scrape_interval: 15s
    honor_labels: true
    metrics_path: '/federate'
    params:
      match[]:
        - '{job=~".+"}'
    #  'match[]':
    #    - '{job="prometheus"}'
    #    - '{__name__=~"job:.*"}'
    static_configs:
      - targets:
        - 'k8sprom.company.ru'
```