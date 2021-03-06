# BACKUP/RESTORE
```
su - postgres -c "pg_basebackup --host=192.168.1.20 --username=replicate --pgdata=/data --wal-method=stream"
su - postgres -c "pg_basebackup -h 172.27.30.51 -U replica -D /var/lib/pgsql/data -P --xlog"
su postgres -c "pg_basebackup -h 192.168.0.200 -D /var/lib/postgresql/9.6/main -P -U replication --xlog-method=stream"
PG_DUMP
#!/bin/bash
# Скрипт для резервного копирования базы данных Naumen Service Desk на Postgresql
# Перед запуском скрипта необходимо
# 1. Указать параметры скрипта, соответствующие реальным значениям: BACKUPDIR, DBNAME, PGUSER, PGBIN, DAYSTOKEEP, SSHUSER, REMOTEHOST, REMOTEDIR
# 2. Убедиться, что pg_dump из-под пользователя, под которым запускается скрипт, подключается к базе данных без ввода логина и пароля
# 3. Настроить доступ по ключу пользователя, под которым будет запускаться скрипт, с сервера скрипта на сервер $REMOTEHOST под пользователем $SSHUSER (ssh-copy-i$
# Пример запуска из cron: 0 0 * * * ./backup_db_pgsql.sh 2>&1 >> /opt/naumen/backup/backup.log

BACKUPDIR="/var/lib/pgsql/11/backups"
DBNAME="nausd4"
PGUSER="nausd4"
PGBIN="/usr/bin"
DAYSTOKEEP="3"
thedate=date +%Y-%m-%d_%H:%M
echo "[INFO] (date +%H:%M:%S) Start backup"
# backup db
mkdir -p $BACKUPDIR
$PGBIN/pg_dump -U $PGUSER -F c -O --verbose --blobs -f $BACKUPDIR/$DBNAME-$thedate.backup $DBNAME
echo "[INFO] (date +%H:%M:%S) database backup completed: du -sh $BACKUPDIR/$DBNAME-$thedate.backup"
# remove old backups
echo "[INFO] (date +%H:%M:%S) remove old files:"
find $BACKUPDIR -type f -name "$DBNAME-*.backup" -mtime +$DAYSTOKEEP -delete -print
echo "[INFO] (date +%H:%M:%S) Done"
PG_DUMP
# DUMP WITH LOGS
pg_dump --no-owner --no-privileges --no-acl --schema-only edc > edc_2811v2.sql 2>> edc_2811v2.log

# DUMP DB
pg_dump -h source-instance-IP -U user --no-owner --no-acl -d database> prod.sql
time: 1h9m

Import:
psql -h cloud-sql-instance-IP -U user -d database < prod.sql
time: 1h44m

# DUMP 1 SCHEMA
pg_dump -h source-instance-IP -U user --schema-only --no-owner --no-acl -d database > prod.sql
--no-acl - dont include GRANT COMMAND
--no-privileges 
--no-owner - pg_restore не пропускает ни одного элемента, но если некоторые импортированные элементы принадлежат разным пользователям, все записи теперь будут принадлежать только одному пользователю.
не указывать владельца и привелегии (pg_restore --no-privileges --no-owner)

# IMPORT
psql -h cloud-sql-instance-IP -U user -d database < prod.sql

# if error ROLE DONT EXIST -  EXPORT GLOBALS
pg_dumpall -g > globals.sql
потом запустить заливку globals.sql и следом импорт бд

# CHECK SCHEMA EXIST
\c edc
SELECT table_schema,table_name FROM information_schema.tables WHERE table_schema='edc_secr';
SELECT table_schema,table_name FROM information_schema.tables WHERE table_name='users';
PG_DUMP  с компресией & LOGICAL REPLICA
BACKUP
1) выполняем бэкап с компрессией
pg_dump -Fc edc > edc_2810.dump
-F – формат 
-с Вывести копию в архивном формате
2) переносим бэкап на другой сервер
3) удаляем старую бд
su postgres
DROP database edc;
Ошибки:
ERROR:  database "edc" is used by an active logical replication slot
DETAIL:  There are 2 active slots.
# Список слотов
select * from pg_replication_slots;
Удаляем слоты:
select pg_drop_replication_slot('edc_bti_object_sub');
select pg_drop_replication_slot('edc_subscription');
ERROR:  replication slot "edc_bti_object_sub" is active for PID 20218
значит идем на реплика-сервер и деактивируем подписки и это автоматически удалит слоты репликации (не забываем переключиться в нужную БД (подписки создаются внутри БД)):
\c edc_dwh
SELECT * FROM pg_subscription;
DROP SUBSCRIPTION "edc_subscription";
DROP SUBSCRIPTION edc_bti_object_sub;
Удаляем нужную БД на мастере:
drop database edc;
Ошибки:
DETAIL:  There are 40 other sessions using the database.
ALTER USER postgres WITH PASSWORD 'postgres';
# переводим БД в запрет подключений
psql -h localhost -U postgres postgres
UPDATE pg_database SET datallowconn = 'false' WHERE datname = 'edc';
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'edc';
DROP DATABASE edc;
## Create DB
# LIST OF TABLESPACES для создания БД
\db

CREATE DATABASE edc
  WITH OWNER = edc
    ENCODING = 'UTF8'
    TABLESPACE = 'general_tbl'
    TEMPLATE = template0
    LC_COLLATE = 'ru_RU.UTF-8'
    LC_CTYPE = 'ru_RU.UTF-8'
    CONNECTION LIMIT = -1;
```

# RESTORE
```
pg_restore -d edc edc_2810.dump

#отслеживать можно изменением размера дб
SELECT pg_database_size('edc');
SELECT pg_size_pretty(pg_database_size('edc'));
SELECT pg_last_xact_replay_timestamp();

# полтора часа шло 120гб
#восстанавливаем реплика слоты - идем на реплика сервер
\c edc_dwh
SELECT * FROM pg_subscription;

CREATE SUBSCRIPTION edc_subscription
    CONNECTION 'host=172.17.58.31 port=5432 user=edc dbname=edc'
    PUBLICATION edc_subscription;

CREATE SUBSCRIPTION edc_bti_object_sub
    CONNECTION 'host=172.17.58.31 port=5432 user=edc dbname=edc'
    PUBLICATION edc_bti_object_sub;

Проверка на реплике
SELECT * FROM pg_subscription;

Проверка на мастере
select * from pg_replication_slots;
```

PG_DUMP
сделать копию одной бд постгрес - pg_dump – bd 9.4
#backup 1 db
su postgres
pg_dump -U postgres ts_resource_plan > ts_resource_plan.sql
postgres - владелец бд
ts_resource_plan - название бд
ts_resource_plan.sql - дамп бд

#restore 1 db
```
Для лучшего результата лучше удалить старую БД
DROP DATABASE "ts_antoshina";
```
# if exist active connections  
```
SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'ts_antoshina' AND pid <> pg_backend_pid();
CREATE DATABASE "ts_antoshina";
#restore
su postgres
psql -U postgres -d ts_antoshina -f ts_resource_plan.sql
-U postgres - owner db
-d ts_antoshina - имя_бд
-f ts_resource_plan.sql - дамп бд
PG_DUMPALL
su postgres
pg_dumpall -c -U postgres | gzip > dump_`date +%d-%m-%Y"_"%H_%M_%S`.gz
```
# RESTORE
````
CREATE DATABASE monitor;
gunzip -c dump_20-05-2019_10_10_25.gz | psql -U monitor -d monitor
PG_DUMPALL in DOCKER
#!/bin/sh
```
# Dump DBs
```
#now=$(date +"%d-%m-%Y_%H-%M")
docker exec -t opencity_db_primary.1.tu288umrzgazjhndy3sf9mw7s pg_dumpall -c -U postgres | gzip > dump_`date +%d-%m-%Y"_"%H_%M_%S`.gz

# remove all files (type f) modified longer than 30 days ago under /db_backups/backups
find /db_backups/backups -name "*.gz" -type f -mtime +30 -delete

exit 0

crontab -e
i
ctrl+v
ctrl+c
каждую субботу бэкап в 22-00
0 1 * * * /opt/backup_script/backup.sh >> /opt/backup/backup.log
RESTORE
cat your_dump.sql | docker exec -i your-db-container psql -U postgres
PG_RESTORE
Использования скрина для создания новой сессии и выполнения в ней задач
screen pg_restore --create -j 8 -h localhost -Fc -p 5432 -U postgres  -d postgres edc_dwh_2011.dump
-Fc - восстановление из архивного дампа (в котором было -Fc)
-j 8 - восстановление в 8 потоков (8 ядер)
--create - создает БД из дампа
--clean
-d postgres - используется для подключения к БД и создания удаление нужной бд, не будет в нее заливаться
```
