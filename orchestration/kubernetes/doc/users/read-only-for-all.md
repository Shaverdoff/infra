---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: rvuser-sa
  namespace: kube-system
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: rvuser-role
  namespace: kube-system
rules:
- apiGroups: 
  - ""
  resources: ["*"]
  verbs:
  - get 
  - list
  - watch
- apiGroups: ["extension"]
  resources: ["*"]
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - apps
  resources: ["*"]
  verbs:
  - get
  - list
  - watch
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: rvuser-rolebind
subjects:
- kind: ServiceAccount
  name: rvuser-sa
  namespace: kube-system
roleRef:
  kind: ClusterRole
  name: rvuser-role
  apiGroup: rbac.authorization.k8s.io
```
