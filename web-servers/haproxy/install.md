### HAProxy кластер
```
Настройки sysctl
В /etc/sysctl.d/00-ansible.conf прописать
net.ipv4.ip_nonlocal_bind = 1
net.ipv4.ip_forward = 1
и применить
/usr/sbin/sysctl -p /etc/sysctl.d/00-ansible.conf
Настройки SELinux
setsebool -P virt_sandbox_use_netlink 1
setsebool -P domain_kernel_load_modules 1

```
