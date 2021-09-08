# Migrating to the systemd driver for kubelet and docker
```
# kubelet cgroup driver: "cgroupfs" is different from docker cgroup driver: "systemd"
1) change in configmap
kubectl get cm -n kube-system | grep kubelet-config
kubectl edit cm kubelet-config-x.yy -n kube-system
export EDITOR=nano
kubectl edit cm kubelet-config-1.20 -n kube-system
# Either modify the existing cgroupDriver value or add a new field that looks like this:
cgroupDriver: systemd

2) change on docker side
nano /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "bip": "211.211.3.1/24",
  "dns": ["10.233.0.3", "10.3.0.25", "10.3.0.10"],
  "dns-search": ["default.svc.k8s-ops.cluster", "svc.k8s-ops.cluster", "rendez-vous.ru"],
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

3) better recreate node
4) or change existing
# MIGRATE FROM CGGROUP TO SYSTEMD DRIVER
kubectl drain <node-name> --ignore-daemonsets
kubectl drain k8s-ops03 --ignore-daemonsets
systemctl stop kubelet
# stop container runtime
systemctl stop docker
# Modify the container runtime cgroup driver to systemd
nano /var/lib/kubelet/config.yaml
cgroupDriver: systemd 
systemctl start docker
systemctl start kubelet
kubectl uncordon k8s-ops03
```
