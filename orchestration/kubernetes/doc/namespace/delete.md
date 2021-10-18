# delete namespace <your_namespace> force
```
export namespace=openebs
kubectl get ns $namespace -o json  > tmp.json
nano @tmp.json
finalizers: []
kubectl proxy --address='0.0.0.0' --port=8001 --accept-hosts='.*'
curl -k -H "Content-Type: application/json" -X PUT --data-binary   @tmp.json http://127.0.0.1:8001/api/v1/$namespace/openebs/finalize

# OR
kubectl patch ns <your_namespace> -p '{"metadata":{"finalizers":null}}'
kubectl delete ns <your_namespace>
```
