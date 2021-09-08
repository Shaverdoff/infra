### PLEG is not healthy: pleg was last seen active 5m40.667485397s ago; threshold is 3m0s
```
kube-proxy was not running on that node
recreate and its working!
```
### "cni0" already has an IP address different from 10.244.10.1/24
```
issue was getted after readd node or change network driver from flannel to calico
# solution
1) just delete existing driver
ip link delete cni0
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
ip link delete cni0
ip link delete flannel.1

systemctl start docker kubelet
# readd node to cluster
kubeadm join ...

```
