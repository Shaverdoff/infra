# PGPOOL2
```
Репозиторий
# RHEL 7
yum install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-redhat96-9.6-3.noarch.rpm
# CentOS 7
yum install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
Установка
Ставим пакеты:
yum install pgpool-II-96 postgresql96
```
### Настройка одиночного режима
```
Простой вариант, когда pgpool один, а серверов с БД два - мастер и слейв. Авторизация trust, фейловер с мастера на слейв не используется

/etc/pgpool-II-96/pgpool.conf:
listen_addresses = '*'
port = 9999
pid_file_name = '/var/run/pgpool-II-96/pgpool.pid'
log_destination = 'syslog'
 
backend_hostname0 = 'IP_POSTGRES_MASTER'
backend_port0 = 5432
backend_weight0 = 1
backend_data_directory0 = '/var/lib/pgsql/9.6/data'
backend_flag0 = 'DISALLOW_TO_FAILOVER'
 
backend_hostname1 = 'IP_POSTGRES_SLAVE'
backend_port1 = 5432
backend_weight1 = 1
backend_data_directory1 = '/var/lib/pgsql/9.6/data'
backend_flag1 = 'DISALLOW_TO_FAILOVER'
 
connection_cache = on
 
# Disable pgpool replication because we use native stream replication
replication_mode = off
 
# Activate load balancing mode
load_balance_mode = on
master_slave_mode = on
master_slave_sub_mode = 'stream'
Нужно только изменить значения IP_POSTGRES_MASTER и IP_POSTGRES_SLAVE на адреса серверов БД - мастера и слейва соответственно. И запустить pgpool:

systemctl enable pgpool-II-96
systemctl start pgpool-II-96
```
### Настройка master-slave режима
```
Подразумевается что у нас два сервера с БД - мастер и слейв, которые используют для доступа исключительно md5 авторизацию, а так же две ноды с pgpool, на которых так же настроена авторизация по md5. В случае с trust некоторые действия будут не нужны. В случае выхода из строя мастера БД будет выполнено переключения слейва в режим мастера

Master
/etc/pgpool-II-96/pgpool.conf:
listen_addresses = '*'
port = 9999
pid_file_name = '/var/run/pgpool-II-96/pgpool.pid'
log_destination = 'syslog'
 
backend_hostname0 = 'IP_POSTGRES_MASTER'
backend_port0 = 5432
backend_weight0 = 1
backend_data_directory0 = '/var/lib/pgsql/9.6/data'
backend_flag0 = 'ALLOW_TO_FAILOVER'
 
backend_hostname1 = 'IP_POSTGRES_SLAVE'
backend_port1 = 5432
backend_weight1 = 1
backend_data_directory1 = '/var/lib/pgsql/9.6/data'
backend_flag1 = 'ALLOW_TO_FAILOVER'
 
connection_cache = on
 
# Disable pgpool replication because we use native stream replication
replication_mode = off
 
# Activate load balancing mode
load_balance_mode = on
master_slave_mode = on
master_slave_sub_mode = 'stream'
 
# Login and password for stream replication check
sr_check_user = 'postgres'
sr_check_password = 'postgres'
 
# Health check
health_check_user = 'postgres'
health_check_password = 'postgres'
health_check_database = ''
# !!Important!! health_check_timeout must be shorter enough than health_check_period
health_check_period = 20
health_check_timeout = 10
 
# Enable pool_hba.conf for client authentication
enable_pool_hba = true 
 
failover_command = '/etc/pgpool-II-96/failover.sh %d %P %H %R failover'
 
# Activate watchdog
use_watchdog = on
 
delegate_IP = 'IP_PGPOOL_VIP'
wd_hostname = 'IP_PGPOOL_MASTER'
wd_port = 9000
 
ifconfig_path = '/sbin'
if_up_cmd = 'ifconfig ens192:0 inet $_IP_$ netmask 255.255.255.128'
if_down_cmd = 'ifconfig ens192:0 down'
arping_path = '/sbin'
arping_cmd = 'arping -I ens192 -U $_IP_$ -w 1'
 
wd_lifecheck_method = 'heartbeat'
wd_interval = 3
wd_heartbeat_port = 9694
heartbeat_destination0 = 'IP_PGPOOL_SLAVE'
heartbeat_destination_port0 = 9694
other_pgpool_hostname0 = 'IP_PGPOOL_SLAVE'
other_pgpool_port0 = 9999
other_wd_port0 = 9000
В конфиге следует изменить следующие значения:

Вместо IP_POSTGRES_MASTER указать адрес мастера БД, а вместо IP_POSTGRES_SLAVE соответственно слейва
Так же необходимо указать под каким логином и паролем pgpool должен проверять состояние БД и состояние ее репликации. За это отвечают параметры health_check_user/health_check_password и sr_check_user/sr_check_password соответственно. В примере это postgres/postgres в обоих случаях
Вместо IP_PGPOOL_MASTER и IP_PGPOOL_SLAVE указываем адреса первой и второй ноды. Вместо IP_PGPOOL_VIP отдельный адрес, который будет использоваться для балансировки
В параметрах if_up_cmd, if_down_cmd и arping_cmd меняем ens192 на имя интерфейса, который должен слушать pgpool. Так же указываем правильную маску сети
Slave
/etc/pgpool-II-96/pgpool.conf:
listen_addresses = '*'
port = 9999
pid_file_name = '/var/run/pgpool-II-96/pgpool.pid'
log_destination = 'syslog'
 
backend_hostname0 = 'IP_POSTGRES_MASTER'
backend_port0 = 5432
backend_weight0 = 1
backend_data_directory0 = '/var/lib/pgsql/9.6/data'
backend_flag0 = 'ALLOW_TO_FAILOVER'
 
backend_hostname1 = 'IP_POSTGRES_SLAVE'
backend_port1 = 5432
backend_weight1 = 1
backend_data_directory1 = '/var/lib/pgsql/9.6/data'
backend_flag1 = 'ALLOW_TO_FAILOVER'
 
connection_cache = on
 
# Disable pgpool replication because we use native stream replication
replication_mode = off
 
# Activate load balancing mode
load_balance_mode = on
master_slave_mode = on
master_slave_sub_mode = 'stream'
 
# Login and password for stream replication check
sr_check_user = 'postgres'
sr_check_password = 'postgres'
 
# Health check
health_check_user = 'postgres'
health_check_password = 'postgres'
health_check_database = ''
# !!Important!! health_check_timeout must be shorter enough than health_check_period
health_check_period = 20
health_check_timeout = 10
 
# Enable pool_hba.conf for client authentication
enable_pool_hba = true 
 
failover_command = '/etc/pgpool-II-96/failover.sh %d %P %H %R failover'
 
# Activate watchdog
use_watchdog = on
 
delegate_IP = 'IP_PGPOOL_VIP'
wd_hostname = 'IP_PGPOOL_SLAVE'
wd_port = 9000
 
ifconfig_path = '/sbin'
if_up_cmd = 'ifconfig ens192:0 inet $_IP_$ netmask 255.255.255.128'
if_down_cmd = 'ifconfig ens192:0 down'
arping_path = '/sbin'
arping_cmd = 'arping -I ens192 -U $_IP_$ -w 1'
 
wd_lifecheck_method = 'heartbeat'
wd_interval = 3
wd_heartbeat_port = 9694
heartbeat_destination0 = 'IP_PGPOOL_MASTER'
heartbeat_destination_port0 = 9694
other_pgpool_hostname0 = 'IP_PGPOOL_MASTER'
other_pgpool_port0 = 9999
other_wd_port0 = 9000
Значение исправляем аналогично как на мастере

Общие настройки обоих нод
/etc/pgpool-II-96/pool_hba.conf:

Дописываем строку

host all     all  0.0.0.0/0       md5
То есть разрешаем откуда угодно подключаться через pgpool к любым базам используя md5 авторизацию

Далее генерируем /etc/pgpool-II-96/pool_passwd:

pg_md5 -m -u логин пароль
Логин и пароль указываем аналогичные тем, что и у пользователя в БД. Т.е, если в БД есть пользователь tuchinskiyak с паролем passwd, то указываем их тут

Создаем скрипт, который будет выполнять failover на мастере БД - /etc/pgpool-II-96/failover.sh:

#!/bin/bash -x
 
FALLING_NODE=$1
OLDPRIMARY_NODE=$2      # %P
NEW_PRIMARY=$3          # %H
PGDATA=$4               # %R
TRIGGER_FILE=$5
 
if [ $FALLING_NODE = $OLDPRIMARY_NODE ]; then
   if [ $UID -eq 0 ]
   then
        su postgres -c "ssh -o StrictHostKeyChecking=no -T postgres@$NEW_PRIMARY touch $PGDATA/$TRIGGER_FILE"
   else
        ssh -o StrictHostKeyChecking=no -T postgres@$NEW_PRIMARY touch $PGDATA/$TRIGGER_FILE
   fi
   exit 0;
fi;
exit 0;
Теперь что бы этот скрипт мог успешно выполняться нужно обеспечить доступ по ключу с серверов pgpool на сервера БД. Для этого на серверах pgpool создаем УЗ postgres и от ее имени генерируем ssh ключи, публичную часть которых помещаем в .ssh/authorized_keys пользователя postgres на серверах БД

После этого стартуем pgpool на обоих серверах:

systemctl enable pgpool-II-96
systemctl start pgpool-II-96
Проверить состояние можно следующими способами:

На одном из серверов, который в результате выборов стал мастером, должен появиться новый сетевой интерфейс с адресом указанным в параметре delegate_IP конфига pgpool.conf
Подключившись через pgpool можно посмотреть состояние балансировки запросов - show pool_nodes;
pgpool сохраняет состояние каждого сервера БД в файл /tmp/pgpool_status. В случае если сервер БД доступен, а pgpool считает что нет, то достаточно этот файл удалить и перезапустить pgpool. Либо сделать это через интерфейс PCP

```
