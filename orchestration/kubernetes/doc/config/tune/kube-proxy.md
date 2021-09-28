# Change mode to ipvc
```
Edit the configmap
kubectl edit configmap kube-proxy -n kube-system
change mode from "" to ipvs

mode: ipvs
Kill any kube-proxy pods

kubectl get po -n kube-system
kubectl delete po -n kube-system <pod-name>
Verify kube-proxy is started with ipvs proxier

kubectl -n kube-system  logs [kube-proxy pod] | grep "Using ipvs Proxier"
```
