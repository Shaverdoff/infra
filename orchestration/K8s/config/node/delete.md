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

2) delete all
# delete node from cluster
kubeadm reset
systemctl stop kubelet
systemctl stop docker
rm -rf /var/lib/cni/
rm -rf /var/lib/kubelet/*
rm -rf /etc/cni/
ifconfig cni0 down
ifconfig flannel.1 down
ifconfig docker0 down
```
