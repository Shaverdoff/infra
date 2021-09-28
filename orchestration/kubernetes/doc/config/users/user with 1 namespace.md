

```
kubectl create -f access.yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: username
  namespace: namespace_name
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: username-full-access
  namespace: namespace_name
rules:
- apiGroups: ["", "extensions", "apps"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["batch"]
  resources:
  - jobs
  - cronjobs
  verbs: ["*"]
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: dagster-user-view
  namespace: dagster-240-prod
subjects:
- kind: ServiceAccount
  name: username
  namespace: namespace_name
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: username-full-access

```
###
```
kubectl describe sa username -n namespace_name

```