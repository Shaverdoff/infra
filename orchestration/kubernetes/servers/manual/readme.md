# Common steps for installing k8s
```
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




