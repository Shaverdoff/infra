# Install with helm
```
# https://github.com/kubernetes/dashboard/tree/master/aio/deploy/helm-chart/kubernetes-dashboard
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo update
helm delete kubernetes-dashboard -n kubernetes-dashboard
export domain=k8s-test.company.ru
kubectl create ns kubernetes-dashboard
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard -n kubernetes-dashboard \
--set extraArgs="{--token-ttl=0}" \
--set ingress.enabled=true \
--set ingress.paths[0]=/ \
--set ingress.hosts[0]=$domain \
--set ingress.annotations."kubernetes\.io/ingress\.class"=nginx \
--set metricsScraper.enabled=true \
--set metrics-server.enabled=true  \
--set metrics-server.args="{--kubelet-preferred-address-types=InternalIP,--kubelet-insecure-tls}" 
```

#### Создаем ServiceAccount для входа в борду:
```
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF
```

#### verify
```
kubectl -n kubernetes-dashboard get pods
kubectl get deployment metrics-server -n kube-system
yum install jq -y
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
```
