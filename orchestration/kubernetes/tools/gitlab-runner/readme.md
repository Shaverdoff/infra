# Add gitlab-runner with helm
```
# https://gitlab.com/gitlab-org/charts/gitlab-runner/blob/main/values.yaml

# namespace
kubectl create ns gitlab-runner

# set labels to the nodes
kubectl label node k8s-tst2 gitlab-worker=true --overwrite
kubectl label node k8s-tst3 gitlab-worker=true --overwrite

# Role
cat <<EOF | kubectl create -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: gitlab-runner
  namespace: gitlab-runner
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["list", "get", "watch", "create", "delete"]
  - apiGroups: [""]
    resources: ["pods/exec"]
    verbs: ["create"]
  - apiGroups: [""]
    resources: ["pods/log"]
    verbs: ["get"]
EOF

kubectl create rolebinding --namespace=gitlab-runner gitlab-runner-binding --role=gitlab-runner --serviceaccount=gitlab-runner:default
kubectl create clusterrolebinding default --clusterrole=cluster-admin --group=system:serviceaccounts --namespace=gitlab-runner
helm upgrade --install --namespace gitlab-runner  gitlab-runner -f values.yaml gitlab/gitlab-runner
```
