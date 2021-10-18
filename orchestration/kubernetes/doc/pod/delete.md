# delete POD force
```
kubectl delete -n ingress-nginx pod ingress-nginx-controller-5ccbdc65bc-6k4nk --grace-period=0 --force
kubectl delete pod <PODNAME> --grace-period=0 --force --namespace <NAMESPACE>
```
