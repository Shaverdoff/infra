```
kubectl create ns logging
helm upgrade --install -f values.yml -n logging fluentbit fluent/fluent-bit
```
