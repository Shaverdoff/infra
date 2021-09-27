# Системные команды
### Подключение к бд
```
su  postgres && psql	
```
### Обновление конфига без перезагрузки БД
```
SELECT pg_reload_conf();	
```
### Выход из консоли
```
\q	
```
### Список баз
```
psql –l
\l
```
### Узнать версию БД
```
select version();
```
### change max_connections
```
SELECT * FROM   pg_settings WHERE  name = 'max_connections';
ALTER SYSTEM SET max_connections TO '900';
postgres check max_con
SHOW max_connections;
```
### VACUUMDB
```
vacuumdb test	Очистить данные бд
```
### Создать табличное пространство
```
CREATE TABLESPACE ИМЯ_tablespace LOCATION '/путь/до/директории';	
Стоит учитывать что директория должна уже быть создана и владелец должен быть postgres
```
### Запрос текущего pg_hba.conf
```
SELECT pg_read_file('pg_hba.conf');
psql -U postgres -c 'SHOW hba_file'
```
### Запрос postgresql.conf
```
psql -U postgres -c 'SHOW config_file'
```
### Запрос текущего wal_level
```
select name, setting, sourcefile, sourceline from pg_settings where name = 'wal_level';
```
### вычленить 2 часа лога из файла
```
sed -n "/^$(date --date="120 minutes ago" "+%Y-%m-%d %H:%M")/,\$p" postgresql-Thu.log >> 120min	
```
### Размер базы данных
```
SELECT pg_size_pretty(pg_database_size('namedb' ));
```
### Создание базы данных
```
CREATE DATABASE teamcity;	
```
### Сменить владельца БД
```
ALTER DATABASE namedb OWNER TO nameuser;	
```

	
