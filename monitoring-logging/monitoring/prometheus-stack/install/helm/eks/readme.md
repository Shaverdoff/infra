# PROMETHEUS
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
