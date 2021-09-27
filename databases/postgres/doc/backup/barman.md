# barman
```
BARMAN
https://www.pgbarman.org/faq/backup/
Есть два способа бекапа - используя streaming replication самого PostgreSQL и бекап через ssh/rsync. Первый вариант рекомендуется использовать при PostgreSQL >= 9.4 и для него нужна поддержка слотов репликации (появились как раз в 9.4). Во втором варианте созданные WAL сегменты будут отправляться на сервер бекапа при помощи rsync (параметр archive_command на мастере)

BARMAN команды
описание	команды
Список бэкапов бд opencity_reports	barman list-backup opencity_reports
Удаление бэкапа по ID (например если он failed)	barman delete opencity_reports 20190211T140031
Бэкап бд	barman backup opencity_reports
	
	

BARMAN-RSYNC
http://rajeshmadiwale.blogspot.com/2016/03/barmanbackup-and-recovery-manager-is.html
# Install repository
sudo wget https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm -e use_proxy=yes -e http_proxy=37.29.76.196:443
sudo rpm -ivh pgdg-centos96-9.6-3.noarch.rpm
#install barman on barman-server
sudo yum -y install barman
#если надо создать пользователя
useradd barman -p barman -d /home/barman
passwd barman #set password barman
STEP 1 – Создание ключей на каждом сервере (postgre & barman server’s)
on barman-server
###Создайте ключи на каждом сервере и скопируйте их
su - barman
ssh-keygen
#copy key auto
ssh-copy-id -i .ssh/id_rsa.pub postgres@192.168.22.136
#copy key manual
cat ~/.ssh/id_rsa.pub
#go on server with pg96
sudo su - postgres
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+fB87nOJnRD8vDtaV/037/h1c2jUXqgT30U/7aHUvZQGSrKbtyNNcS32X3utfD9mEhFisW+irYfjDYiiWMgc22LU+vwLiQ40gsNsgMDvIbD/Ka/p+2eHcuWzsRHkVhWulf0n7hgh1b/p3x1myheIW5ihjpn33iqDfJzVwP/4hfRh86Hjr/fWG1OuHUv7HLX3bFaLwGsdsyvO+e9JISComeBgNxZkZGII2tLHoRtzqyy/tfSDmqQ145EbMiwoJn88aezCiOtwR/D/j30mTzTN+m/Cgb2dZEAXLdyVJlQZmTc7sokGRh2NtFseu1LuUzYD3BrTsXwOe/gvD8YidVSDj barman@EV-REQ-STORAGE.chbtk.net" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
#check connect in server with barman
ssh -vv 'postgres@server-postgres
Дополнительно
#если при авторизации по ключу требует пароль отключите selinux
если не пускает после этого
Проверьте чтобы в /etc/ssh/sshd_config был разрешён вход по ключу
cat /etc/ssh/sshd_config | grep PubkeyAuthentication
#PubkeyAuthentication yes

###############ON SERVER WITH PG96
sudo su - postgres
ssh-keygen
#copy public_key on barman-server
cat ~/.ssh/id_rsa.pub
ssh-copy-id -i .ssh/id_rsa.pub barman@172.16.4.6
#check connect on barman-server
ssh 'barman@172.16.4.6'
chmod -R 0700 /home/user
STEP 2 – Настройка конфигов для бэкапа
################on server with barman - where configs
sudo nano /etc/barman.conf
[barman]
compression = gzip				
barman_home = /opt/data/backup_opencity_reports
log_file = /opt/data/backup_opencity_reports/barman.log
где:
compression = gzip				; сжимаем полученные WAL
barman_home = /opt/data/backup_opencity_reports		  ; каталог хранения бекапов

#создаем файл конфигурации БД всегда с уникальным именем (имя должно совпадать с идентификатором в квадратных скобках)
nano /etc/barman.d/opencity_reports.conf
[opencity_reports]
description = "opencity_reports"
ssh_command = ssh postgres@192.168.22.136
conninfo = host=192.168.22.136 user=postgres dbname=opencity_reports 
archiver=on
backup_method = rsync
reuse_backup = link  
retention_policy = RECOVERY WINDOW OF 7 DAYS   нам откатиться на 7 дней назад
minimum_redundancy = 3 
last_backup_maximum_age = 7 DAYS 
где:
ssh_command = ssh postgres@192.168.22.136 - ; указать мастер PostgreSQL
conninfo = host=192.168.22.136 user=postgres dbname=opencity_reports  - ; параметры подключения к БД
reuse_backup = link      ; дедупликация с помощью rsync + hard links при создании полного бекапа
retention_policy = RECOVERY WINDOW OF 7 DAYS     ; храним такое количество копий, которое позволит нам откатиться на 7 дней назад
minimum_redundancy = 3         ; минимальное количество бекапов которое должно присутствовать всегда
last_backup_maximum_age = 7 DAYS                                               ; максимальный возраст бекапа

STEP 3 – Создание каталога для хранения бэкапов
##on barman-server
#найти значение входящего каталога резервного копирования с сервера barman-backup-server 
barman show-server opencity_reports | grep incoming_wals_directory
incoming_wals_directory: /opt/data/backup_opencity_reports/opencity_reports/incoming
где opencity_reports  - это идентификатор БД из STEP 2

#если изменили директорию хранения бэкапов - добавьте разрешения и смените владельца
chown barman:barman -R /opt/data/backup_opencity_reports

#for test connect
psql 'host=192.168.22.136 user= postgres dbname=opencity_reports'
psql -h 192.168.22.136 -p 5432 -U postgres opencity_reports

STEP 4 – Настройка конфигов БД postgres
edit postgresql.conf
nano /data/pgsql/96/postgresql.conf
wal_level=archive
archive_mode=on
archive_command='rsync -a %p barman@172.16.4.6:/opt/data/backup_opencity_reports/opencity_reports/incoming/%f'
!!!!!!! archive_command - установите значение из incoming_wals_directory STEP 3
psql: FATAL:  no pg_hba.conf entry for host "192.168.22.136", user "opencity_reports", database "opencity_reports", SSL off
nano pg_hba.conf
host    postgres                postgres                192.168.22.136/32   trust
host    opencity_reports  postgres                172.16.4.6/32       trust
systemctl restart postgresql-9.6.service

STEP 5 – Проверка соединения
#on server with barman
su - barman
barman check opencity_reports
где opencity_reports  - это идентификатор БД из STEP 2

#результат
barman check opencity_reports
Server opencity_reports:
        PostgreSQL: OK
        is_superuser: OK
        wal_level: OK
        directories: OK
        retention policy settings: OK
        backup maximum age: FAILED (interval provided: 7 days, latest backup age: No available backups)
        compression settings: OK
        failed backups: OK (there are 0 failed backups)
        minimum redundancy requirements: FAILED (have 0 backups, expected at least 3)
        ssh: OK (PostgreSQL server)
        not in recovery: OK
        archive_mode: OK
        archive_command: OK
        continuous archiving: OK
        archiver errors: OK

Для больше информации - barman show-server opencity_reports

ОШИБКИ:
WARNING: No archiver enabled for server 'opencity_reports'. Please turn on 'archiver', 'streaming_archiver' or both
WARNING: Forcing 'archiver = on'
В конфиге DB для бармана добавьте 
archiver = on

Ошибка:
WAL archive: FAILED (please make sure WAL shipping is setup)
barman switch-xlog --force --archive opencity_reports

Ошибка при barman check opencity_reports - значит что барман не может подключиться к бд - может проблема в firewalld & selinux
PostgreSQL: FAILED
Помогло:
sudo firewall-cmd --permanent --zone=trusted --add-source=172.29.74.45/32

Бэкап БД
#делаем полный бэкап БД
barman backup opencity_reports
Инкрементальный бэкап БД
# на базе например изменилось что-то - выполняем инкрементальный бэкап (т.е. используем существующим бэкап и дополняем его изменившимися файлами)
barman backup --reuse=link opencity_reports
# Для показа списка бэкапов
barman list-backup opencity_reports
pgdb 20190130T111943 - Wed Jan 30 11:19:46 2019 - Size: 29.2 MiB - WAL Size: 0 B
pgdb 20190130T111519 - Wed Jan 30 11:15:25 2019 - Size: 29.2 MiB - WAL Size: 58.0 KiB
pgdb 20190130T111403 - Wed Jan 30 11:14:06 2019 - Size: 29.2 MiB - WAL Size: 89.2 KiB
pgdb 20190130T110646 - Wed Jan 30 11:06:48 2019 - Size: 21.9 MiB - WAL Size: 108.2 KiB
!!!!!!!!!CRON
export EDITOR=nano
или можно добавить в cron.d 
nano /etc/cron.d/barman
#запускать каждый день в час ночи бэкап БД-идентификатор
  0 01   *   *   *   barman   [ -x /usr/bin/barman ] && /usr/bin/barman -q backup opencity_reports
# удалить старые бэкапы
  0 03   *   *   *   barman   [ -x /usr/bin/barman ] && /usr/bin/barman -q delete opencity_reports oldest
STEP 7 - Восстановление
#on barman-server
# Восстановление из бэкапа на последнюю инкрементальную копию
barman recover pgdb 20190130T111943 /tmp/data
# RESTORE восстанавливается в папку /tmp/data, а при восстановлении пользователь должен предоставить последний идентификатор резервной копии
barman recover pgdb latest /tmp/data
#Now change owner of /tmp/data as 'postgres' and start the recovered instance.
chown -R postgres:postgres data
ls –lrth
BARMAN-REPLICATION
Postgres – находится в docker-контейнере на 1 сервере
Barman – 2 сервер

docker run  --name postgres3 \
-e POSTGRES_PASSWORD=mysecretpassword \
-p 5432:5432 \
-d postgres:9.4
docker exec -it postgres3 bash
apt-get update && apt-get install nano -y
cd /var/lib/postgresql/data
# разрешаем подключаться без пароля от сервера с barman
nano pg_hba.conf
host    postgres        postgres 172.29.74.45/32 trust    # сервер бекапа
host    replication postgres  172.29.74.45/32 trust  # сервер бекапа. Подключения для процесса репликации

nano postgresql.conf
max_wal_senders = 10  «number_of_replicas + 1»; учитываются в общем кол-ве соединений к серверу max_connections; так же, можно задать max_replication_slots
max_replication_slots = 10
wal_keep_segments = 1000; количество файлов WAL в директории pg_xlog/, которое будет храниться в папке с данными (по умолчанию, 16mb/файл);
оно должно быть достаточным для того, чтобы обеспечить реплике успевание их стягивать при потоковой репликации;
в противном случае, вы рискуете получить ситуацию, когда мастер удалит файлы журналов, которые ещё не были скопированы на реплику, и репликация сломается;
если у вас активная запись в БД, и за время «лага репликации» вы успеваете выбрать это количество — вам стоит его увеличить.
listen_addresses = '*'
wal_level=archive  (или выше); необходимо для того, чтобы WAL-логи содержали информацию, необходимую для работы streaming replication
docker restart postgres3
# ON SERVER WITH BARMAN
nano /etc/barman.conf
[barman]
barman_user = barman
configuration_files_directory = /etc/barman.d
barman_home = /var/lib/barman                                                                      ; каталог хранения бекапов
log_file = /var/log/barman/barman.log
log_level = INFO
compression = gzip                                                                                 ; сжимаем полученные WAL

nano /etc/barman.d/pgdb3.conf
[pgdb3]
description =  "pgdb3 (streaming)"
conninfo = host=172.29.74.49 user=postgres dbname=postgres
streaming_conninfo = host=172.29.74.49 user=postgres
backup_method = postgres
streaming_archiver = on 	                            ; включаем доставку логов через механизм репликации
slot_name = barman 				; имя слота репликации
archiver = off 					; выключаем доставку логов через archive_command
path_prefix = "/usr/pgsql-9.6/bin"   	             ; путь по которому искать нужную версию pg_receivexlog 
retention_policy = RECOVERY WINDOW OF 7 DAYS         ; храним количество копий, для отката на 7 дней
minimum_redundancy = 3                                      ; минимальное количество бэкапов
last_backup_maximum_age = 7 DAYS                  ; максимальный возраст бекапа

#создание слота для бармана - на сервере бармана
sudo barman receive-wal --create-slot pgdb1
для проверки
barman receive-wal --drop-slot pgdb3
barman receive-wal --create-slot pgdb3
barman receive-wal pgdb3
или 2 способ на сервере - postgres
psql
SELECT pg_create_physical_replication_slot('barman');
\q
Exit

#check
barman check pgdb3
psql -c 'SELECT version()' -U postgres -h 172.29.74.49 postgres

```
