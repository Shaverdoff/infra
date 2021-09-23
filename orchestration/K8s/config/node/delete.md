# DELETE NODE
##### Mark node "foo" as unschedulable.
```
kubectl cordon foo
```
#### drain node foo
```
kubectl drain foo --ignore-daemonsets
```
#### remove node foo
```
kubectl delete node foo
```
#### check nodes
```
kubectl get nodes
```
#### connect to deleted node!
#### reset all
```
kubeadm reset
```

# delete software
```
# If your cluster was setup to utilize IPVS, run ipvsadm --clear (or similar) to reset your system's IPVS tables.
ipvsadm --clear
yum remove kube*
rm -rf /etc/kubernetes /var/lib/kubelet /var/run/kubernetes /var/lib/cni
```
