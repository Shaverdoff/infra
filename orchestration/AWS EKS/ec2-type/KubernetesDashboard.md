# k8s dashboard
```
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
kubectl create ns kubernetes-dashboard
export env=dev
export arn=AWS_ARN dash_url=dash-$env.company.com
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard -n kubernetes-dashboard \
--set extraArgs="{--token-ttl=0}" \
--set ingress.enabled=true --set ingress.paths[0]=/* \
--set ingress.hosts[0]=$dash_url \
--set ingress.annotations."kubernetes\.io/ingress\.class"=alb \
--set ingress.annotations."alb\.ingress\.kubernetes\.io/scheme"=internet-facing \
--set ingress.annotations."alb\.ingress\.kubernetes\.io/target-type"=instance \
--set ingress.annotations."alb\.ingress\.kubernetes\.io/certificate-arn"=$ARN \
--set ingress.annotations."alb\.ingress\.kubernetes\.io/listen-ports"='[{"HTTPS":443}]' \
--set ingress.annotations."alb\.ingress\.kubernetes\.io/backend-protocol"=HTTPS \
--set ingress.annotations."alb\.ingress\.kubernetes\.io/healthcheck-protocol"=HTTPS \
--set service.type=NodePort \
--set metricsScraper.enabled=true --set metrics-server.enabled=true \
--set metrics-server.args="{--kubelet-preferred-address-types=InternalIP,--kubelet-insecure-tls}"
```
#### Создаем ServiceAccount для кластера:
```
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: eks-admin
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: eks-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: eks-admin
  namespace: kube-system
EOF
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
# INGRESS HELM
```
# change dev to your_env in values.yaml
cd dashboard
export env=dev
cp values.yaml values_dev.yaml
nano values_dev.yaml
helm upgrade --install -f ./dashboard/values_$env.yaml -n kubernetes-dashboard dashboard dashboard/

# token TTL
kubectl edit deployment kubernetes-dashboard -n kubernetes-dashboard
- '--token-ttl=0'

# change ClusterIP to type: NodePort
export EDITOR=nano
kubectl edit svc -n kubernetes-dashboard
```

#### verify
```
kubectl -n kubernetes-dashboard get pods
kubectl get deployment metrics-server -n kube-system
yum install jq -y
aws eks get-token --cluster-name $cluster_name | jq -r '.status.token'
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
```
