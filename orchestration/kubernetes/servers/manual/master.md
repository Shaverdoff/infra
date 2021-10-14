# Init master
```
export master_ip='10.3.3.93' KUBE_VERSION=1.22
Note: If 192.168.0.0/16 is already in use within your network you must select a different pod network CIDR, replacing 192.168.0.0/16 in the above command.
cat <<EOF | sudo tee /etc/kubernetes/kubeadm-kubelet-config.yaml
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
localAPIEndpoint:
    advertiseAddress: $master_ip
---
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta3
kubernetesVersion: stable-$KUBE_VERSION
networking:
    podSubnet: 192.168.0.0/16
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cgroupDriver: systemd
EOF

# INIT MASTER
kubeadm init --config /etc/kubernetes/kubeadm-kubelet-config.yaml

# get ready for usage
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

# NETWORK DRIVER
### CALICO with helm v3
```
helm repo add projectcalico https://docs.projectcalico.org/charts
### If you are installing on a cluster installed by EKS, GKE, AKS or Mirantis Kubernetes Engine (MKE), set the kubernetesProvider as described in the Installation reference. For example:
echo '{installation.kubernetesProvider: EKS}' > values.yaml

### Install the Tigera Calico operator and custom resource definitions using the Helm chart:
helm install calico projectcalico/tigera-operator --version v3.20.2
### or if you created a values.yaml above:
helm install calico projectcalico/tigera-operator --version v3.20.2 -f values.yaml
### Confirm that all of the pods are running with the following command.
watch kubectl get pods -n calico-system
### Wait until each pod has the STATUS of Running.

### Install calicoctl as a binary on a single host
!!! CHECK VERSION !!!
curl -o calicoctl -O -L  "https://github.com/projectcalico/calicoctl/releases/download/v3.20.2/calicoctl" 
chmod +x calicoctl
mv calicoctl /usr/bin/
```
