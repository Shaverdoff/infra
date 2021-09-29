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