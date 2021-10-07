# Show all labels
```
kubectl get nodes --show-labels
```
# Add label to node
```
kubectl label node k8s-ops05 node-role.kubernetes.io/worker= --overwrite
kubectl label node rv-site-back05 rvsite= --overwrite
kubectl label node rv-site-back05 node-type=baremetal --overwrite
```
# Remove label
```
kubectl label node k8s-ops07 gitlab-worker-
```
