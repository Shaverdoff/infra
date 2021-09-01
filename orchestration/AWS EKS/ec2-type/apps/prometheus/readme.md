# Install
```
kubectl create ns monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add kube-state-metrics https://kubernetes.github.io/kube-state-metrics
helm repo update
export env=dev
helm upgrade --install prometheus -n monitoring --values values_$env.yml prometheus-community/kube-prometheus-stack
# check
kubectl --namespace monitoring get pods -l "release=prometheus"
```
# EXPORTERS
### CONSUL EXPORTER
```
token=$(kubectl -n consul get secret consul-bootstrap-acl-token -o jsonpath={.data.token} | base64 -d)
echo $token
helm upgrade --install consul-exporter -n monitoring \
  --set consulServer=consul-server.consul:8500 \
  --set=extraEnv[0].name=CONSUL_HTTP_TOKEN,extraEnv[0].value=$token \
  prometheus-community/prometheus-consul-exporter 
```
### BLACKBOX EXPORTER
```
helm upgrade -i blackbox-exporter -n monitoring prometheus-community/prometheus-blackbox-exporter
## add targets to probe
kubectl apply -f blackbox-probe.yml
# checks
export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=prometheus-blackbox-exporter,app.kubernetes.io/instance=blackbox-exporter" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace monitoring $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
echo "Visit http://127.0.0.1:8080 to use your application"
kubectl --namespace monitoring port-forward $POD_NAME 8080:$CONTAINER_PORT --address 0.0.0.0
```

### LOGZIO
```
helm repo add logzio-helm https://logzio.github.io/logzio-helm
# CONNECT PROMETHEUS IN k8s to LOGZIO
# token for logzio - PROMETHEUS-METRICS-SHIPPING-TOKEN
https://app.logz.io/#/dashboard/settings/manage-tokens/data-shipping?product=metrics
# ListenerHost - find your region on below page
https://docs.logz.io/user-guide/accounts/account-region.html
export env=dev 
export token=TOKEN....... ListenerHost="https://listener.logz.io:8053"
helm install  -n monitoring \
--set secrets.MetricsToken=$token \
--set secrets.ListenerHost=$ListenerHost \
--set secrets.p8s_logzio_name=api_$env \
logzio-otel-k8s-metrics logzio-helm/logzio-otel-k8s-metrics

# check metrics here
https://app.logz.io/#/dashboard/metrics/d/61swvitOR40ZEgEIaC3JRG/infrastructure-monitoring-home-dashboard?switchToAccountId=163703
```

### FLUENT BIT
```
## edit version of fluentbit to 1.78
git clone https://github.com/logzio/fluent-bit-logzio-output.git
docker build -t registry.shakticoin.com/logzio/fluent-bit-output:0.0.2 -f test/Dockerfile .
docker run logzio-bit-test

# secret with docker registry creds
kubectl apply -f secret.yml
# install
helm repo add fluent https://fluent.github.io/helm-charts
export env=qa
helm install fluent-bit  -n monitoring --values fluentbit_$env.yml fluent/fluent-bit
```




