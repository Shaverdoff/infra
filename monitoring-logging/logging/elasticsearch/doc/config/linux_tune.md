```

# swappiness
vm.swappiness=0
# These settings are necessary to minimize the chance of packets being dropped during high event rates.
net.core.somaxconn=2048
net.core.netdev_max_backlog=8192
net.core.rmem_max=33554432
net.core.rmem_default=262144
net.ipv4.udp_rmem_min=131072
net.ipv4.udp_mem=2097152 4194304 8388608
vm.max_map_count = 262144
# clear dirty cache page on 10%
vm.dirty_ratio=10
# network
net.ipv4.ip_forward=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=1
vm.max_map_count = 262144
```
