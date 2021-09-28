# Show all labels
```
kubectl get nodes --show-labels
```
# Add label to node
```
kubectl label node k8s-ops05 node-role.kubernetes.io/worker= --overwrite
```
# Remove label
```
kubectl label node k8s-ops07 gitlab-worker-
```
