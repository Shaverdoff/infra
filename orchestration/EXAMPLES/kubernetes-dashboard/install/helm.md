# Install with helm
```
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo update
helm delete kubernetes-dashboard -n kubernetes-dashboard
export domain=company.ru
https://github.com/kubernetes/dashboard/tree/master/aio/deploy/helm-chart/kubernetes-dashboard
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard -n kubernetes-dashboard \
--set extraArgs="{--enable-insecure-login=true}" \
--set ingress.enabled=true --set ingress.paths[0]=/ --set ingress.hosts[0]='dash-k8s.$domain' \
--set ingress.annotations."kubernetes\.io/ingress\.class"=nginx \
--set metricsScraper.enabled=true --set metrics-server.enabled=true  --set metrics-server.args="{--kubelet-preferred-address-types=InternalIP,--kubelet-insecure-tls}" 
```
