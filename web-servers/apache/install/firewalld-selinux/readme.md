```
# FirEWALlD
sudo firewall-cmd --zone=public --list-services
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd –reload
# Selinux apache
sudo yum install policycoreutils-python -y
Разрешение доступа для апач
setsebool -P httpd_can_network_connect 1
```