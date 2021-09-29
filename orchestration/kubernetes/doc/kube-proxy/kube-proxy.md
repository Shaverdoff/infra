# TUNE
```
# Change mode to ipvc
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
# MONITORING
```
# PROMETHEUS-STACK connection refused for kube-proxy
kubectl edit cm kube-proxy-config -n kube-system
## Change from
    metricsBindAddress: 127.0.0.1:10249 ### <--- Too secure
## Change to
    metricsBindAddress: 0.0.0.0:10249

and then recreate kube-proxy pods

# firewall
firewall-cmd --permanent --add-port=10249/tcp
firewall-cmd --reload
```