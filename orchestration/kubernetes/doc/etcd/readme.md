# config
cat /etc/kubernetes/manifests/etcd.yaml
# tune
```
1) etcd needs fast access to disk
2) etcd needs low latency to other etcd nodes, and thus fast networking
3) etcd needs to synchronize data across all etcd nodes before writing data to disk
Therefore, the following recommendations can be made:
1) The etcd store should not be located on the same disk as a disk-intensive service (such as Ceph)
2) etcd nodes should not be spread across datacenters or, in the case of public clouds, availability zones
3) The number of etcd nodes should be 3; you need an odd number to prevent “split brain” problems, but more than 3 can be a drag on performance
```
