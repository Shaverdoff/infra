```
5	Redis кластер
5.1	Настройки sysctl
В /etc/sysctl.d/00-ansible.conf прописать
# Enable memory overcommit
vm.overcommit_memory = 1
и применить
/usr/sbin/sysctl -p /etc/sysctl.d/00-ansible.conf
5.2	Установка
dnf install redis
# Installed:
#  redis-5.0.3-2.module_el8.2.0+318+3d7e67ea.x86_64
 
firewall-cmd --add-ports=16379/tcp --permanent
firewall-cmd --add-ports=6379/tcp --permanent
firewall-smd --reload
systemctl enable --now redis
5.3	Настройка
Указать в конфигурационном файле настройки, заменив  {{ ipv4.address }} и {{ redis_password }} на соответствующие значения
bind {{ ipv4.address }} 127.0.0.1
port 6379
pidfile /var/run/redis.pid
protected-mode yes
requirepass {{ redis_password }}
masterauth {{ redis_password }}
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 15000
cluster-require-full-coverage no
appendonly yes
dir /var/lib/redis
Code Block 19 /etc/redis.conf
systemctl restart redis
Code Block 20 Рестарт сервиса
На мастере выполнить, заменив переменные значениями
{{ redis_master1_ip }}, {{ redis_master2_ip }}, {{ redis_master3_ip }}
{{ redis_slave1_ip }}, {{ redis_slave2_ip }}, {{ redis_slave3_ip }}
{{ redis_password }}
echo yes | redis-cli --cluster create {{ redis_master1_ip }}:6379 {{ redis_master2_ip }}:6379 {{ redis_master3_ip }}:6379 {{ redis_slave1_ip }}:6379 {{ redis_slave2_ip }}:6379 {{ redis_slave3_ip }}:6379 --cluster-replicas 1  -h {{ redis_master1_ip }} -p 6379 -a {{ redis_password }}

```
