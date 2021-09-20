```
helm upgrade --install prometheus -f values.yaml -n monitoring prometheus-community/kube-prometheus-stack

# node export..
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install node-exporter -f node_exporter.yml -n monitoring prometheus-community/prometheus-node-exporter
```
