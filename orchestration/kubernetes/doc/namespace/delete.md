# delete namespace <your_namespace> force
```
kubectl patch ns <your_namespace> -p '{"metadata":{"finalizers":null}}'
kubectl delete ns <your_namespace>
```
