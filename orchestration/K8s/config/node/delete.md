# DELETE NODE
#### Mark node "foo" as unschedulable.
```
kubectl cordon foo
```
### drain node foo
```
kubectl drain foo --ignore-daemonsets
```
### remove node foo
```
kubectl delete node foo
```
### check nodes
```
kubectl get nodes
```
### connect to deleted node!
### reset all
```
kubeadm reset
```

