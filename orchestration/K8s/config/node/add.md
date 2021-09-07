# ADD NEW NODE
### ON MASTER NODE
#### get token
```
kubeadm token create --print-join-command
kubeadm join 10.3.3.58:6443 --token qwewqewqeqeqe --discovery-token-ca-cert-hash sha256:qweq12312321312321321312312312
```

### ON SLAVE MODE
#### Prepare
```
#tc on centos8
dnf install -y iproute-tc

# disable swap
sudo swapoff -a 
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Letting iptables see bridged traffic
Make sure that the br_netfilter module is loaded.
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system


# Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# install docker with "SYSTEMD" driver
nano /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "bip": "211.211.3.1/24",
  "dns": ["10.3.1.1", "10.3.1.2"],
  "dns-search": ["default.svc.k8s-ops.cluster", "svc.k8s-ops.cluster", "company.ru"],
  "dns-opt": ["ndots:2", "timeout:2", "attempts:2"],
  "ipv6": false,
  "iptables": false,
  "data-root": "/var/lib/docker",
  "hosts": ["unix:///var/run/docker.sock"],
  "log-opts": {
    "max-size": "100m", "max-file": "3"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}

nano /etc/systemd/system/docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
BindsTo=containerd.service
After=network-online.target firewalld.service containerd.service
Wants=network-online.target
Requires=docker.socket

[Service]
Type=notify
ExecStart=/usr/bin/dockerd --containerd=/run/containerd/containerd.sock
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutSec=0
TimeoutStartSec=1min
RestartSec=2
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
Delegate=yes
KillMode=process

[Install]
WantedBy=multi-user.target

systemctl enable docker.service
systemctl start docker.service
docker ps -a


# install k8s tools
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

export version="1.20.9"
yum install kubeadm-${version} kubelet-${version} kubectl-${version} --disableexcludes=kubernetes
systemctl enable --now kubelet
kubectl version --client
kubeadm version
```


### ADD NODE
```
# on master get token
kubeadm token create --print-join-command
kubeadm join 10.3.3.58:6443 --token test     --discovery-token-ca-cert-hash sha256:test
# join slave to the cluster
kubeadm join 10.3.3.58:6443 --token qwewqewqeqeqe --discovery-token-ca-cert-hash sha256:qweq12312321312321321312312312
# on master node you can check it with:
kubectl get nodes
# label - node as worker
kubectl label nodes node55 clickhouse=true
kubectl label node node55 node-role.kubernetes.io/worker= --overwrite
```





