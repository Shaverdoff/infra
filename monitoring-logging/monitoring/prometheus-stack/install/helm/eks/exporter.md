# EXPORTERS
## CONSUL-EXPORTER
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
token=$(kubectl -n consul get secret consul-bootstrap-acl-token -o jsonpath={.data.token} | base64 -d)
echo $token
helm upgrade --install consul-exporter -n monitoring \
  --set consulServer=consul-server.consul:8500 \
  --set=extraEnv[0].name=CONSUL_HTTP_TOKEN,extraEnv[0].value=$token \
  prometheus-community/prometheus-consul-exporter
```

## BLACKBOX EXPORTER
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm delete blackbox-exporter -n monitoring
helm upgrade -install blackbox-exporter -n monitoring  -f blackbox-exporter.yml prometheus-community/prometheus-blackbox-exporter
## add targets to probe
kubectl apply -f blackbox-probe.yml
## how check
  export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=prometheus-blackbox-exporter,app.kubernetes.io/instance=blackbox-exporter" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace monitoring $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
kubectl --namespace monitoring port-forward $POD_NAME 8080:$CONTAINER_PORT --address 0.0.0.0
```

