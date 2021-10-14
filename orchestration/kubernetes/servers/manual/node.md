# ADD NEW NODE
```
# on master node get token
kubeadm token create --print-join-command
# join slave to the cluster
kubeadm join master_IP_node:6443 --token qwewqewqeqeqe --discovery-token-ca-cert-hash sha256:qweq12312321312321321312312312
# on master node you can check it with:
kubectl get nodes
# label - node as node
kubectl label node node55 node-role.kubernetes.io/node= --overwrite
```





