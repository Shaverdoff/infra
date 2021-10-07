```
nano /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "bip": "10.220.0.6/24",
  "ipv6": false,
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


dnf install bridge-utils
sudo yum install iptables-services
pkill docker
iptables -t nat -F
ifconfig docker0 down
brctl delbr docker0
docker -d
systemctl restart docker
```
