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

```
