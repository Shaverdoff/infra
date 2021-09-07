# ADD NEW NODE
```
######################
# ON MASTER NODE
######################
# get token
kubeadm token create --print-join-command
kubeadm join 10.3.3.58:6443 --token qwewqewqeqeqe --discovery-token-ca-cert-hash sha256:qweq12312321312321321312312312

######################
# ON SLAVE MODE
######################
# tc on centos8
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







# install docker with "SYSTEMD" driver
nano /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "bip": "10.220.0.1/24",
  "ipv6": false,
  "hosts": ["unix:///var/run/docker.sock"],
  "log-opts": {
    "max-size": "100m", "max-file": "3"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}

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

# Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
export version="1.20.7"
yum install kubeadm-${version} kubelet-${version} kubectl-${version} --disableexcludes=kubernetes
systemctl enable --now kubelet
kubectl version --client
kubeadm version

# join slave to the cluster
kubeadm join 10.3.3.58:6443 --token qwewqewqeqeqe --discovery-token-ca-cert-hash sha256:qweq12312321312321321312312312

# on master node you can check it with:
kubectl get nodes

# label - node as worker
kubectl label nodes node55 clickhouse=true
kubectl label node node55 node-role.kubernetes.io/worker= --overwrite
```

# DELETE NODE
```
# Mark node "foo" as unschedulable.
kubectl cordon foo
# drain node foo
kubectl drain foo --ignore-daemonsets
# remove node foo
kubectl delete node foo
# check nodes
kubectl get nodes

# connect to deleted node!

# reset all
kubeadm reset

# ADD NODE
# on master get token
kubeadm token create --print-join-command

kubeadm join 10.3.3.58:6443 --token test     --discovery-token-ca-cert-hash sha256:test
# LABEL NODE
kubectl label node
```
