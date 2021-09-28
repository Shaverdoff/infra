# Install
```
kubectl create ns jaeger
# dependencies
helm repo add elastic https://helm.elastic.co
helm upgrade --install elasticsearch-jaeger --set replicas=1 -n jaeger elastic/elasticsearch

# repo jaeger
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm search repo jaegertracing

# operator
helm install jaeger-operator jaegertracing/jaeger-operator

# jaeger
helm repo add incubator https://charts.helm.sh/incubator/
export env=dev
helm upgrade --install -f jaeger_$env.yaml -n jaeger jaeger jaegertracing/jaeger

# CHECK
export POD_NAME=$(kubectl get pods --namespace jaeger -l "app.kubernetes.io/instance=jaeger,app.kubernetes.io/component=query" -o jsonpath="{.items[0].metadata.name}")
echo http://127.0.0.1:8080/
kubectl port-forward --namespace jaeger $POD_NAME 8080:16686

```
