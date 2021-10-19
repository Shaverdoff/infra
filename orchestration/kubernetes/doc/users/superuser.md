```
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: rvadmin-sa
  namespace: kube-system
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: rvadmin-rolebind
subjects:
- kind: ServiceAccount
  name: cluster-admin
  namespace: kube-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: rvadmin-sa

```
