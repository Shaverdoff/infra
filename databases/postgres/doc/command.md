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
### наполнение таблиц
```
SELECT * FROM t_random2;
create table t_random5 as select s, md5(random()::text) from generate_Series(1,500000) s;
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
	
# Пользователи
### Перечень подключенных пользователей
```
SELECT datname,usename,client_addr,client_port FROM pg_stat_activity;
```

### Активность пользователя
```
SELECT datname FROM pg_stat_activity WHERE usename = 'devuser';
```
### Активность в бд
```
select * from pg_stat_activity;	
```
# БАЗЫ ДАННЫХ
### Размер базы данных
```
SELECT pg_size_pretty(pg_database_size('namedb' ));
```

# Создание базы данных
```
CREATE DATABASE teamcity;	
```
### Сменить владельца БД
```
ALTER DATABASE namedb OWNER TO nameuser;	
```
# Таблицы
### Узнать размер таблицы
```
SELECT pg_size_pretty( pg_total_relation_size( 'nametable' ) );	
SELECT
       TABLE_NAME,
       pg_size_pretty(pg_table_size(TABLE_NAME)) AS table_size,
       pg_size_pretty(pg_indexes_size(TABLE_NAME)) AS indexes_size,
       pg_size_pretty(pg_total_relation_size(TABLE_NAME)) AS total_size
   FROM (
       SELECT ('"' || table_schema || '"."' || TABLE_NAME || '"') AS TABLE_NAME
       FROM information_schema.tables
   ) AS all_tables
   ORDER BY total_size DESC;
```
# Узнать размер индексов на таблицу,Вывод всех таблиц этой БД с разбивкой на данные, индексы и их сумму.
```
SELECT  t.tablename, psai.indexrelname, pg_relation_size(quote_ident(indexrelname)::text) AS index_size
  FROM pg_tables t
  JOIN pg_class c ON t.tablename = c.relname
  JOIN pg_index x ON c.oid = x.indrelid
  JOIN pg_stat_all_indexes psai ON x.indexrelid = psai.indexrelid
 WHERE t.tablename = 'ИМЯТАБЛИЦЫ';
```
# Перенос объектов БД между табличными пространствами
```
ALTER TABLE ИМЯ_ТАБЛИЦЫ SET TABLESPACE ИМЯ_tablespace;
```
### Перенос таблиц
```
ALTER INDEX ИМЯ_ИНДЕКСА SET TABLESPACE ИМЯ_tablespace;
```
### Посмотреть какие таблицы находятся в табличном пространстве
```
select * from pg_tables where tablespace = 'ИМЯ_tablespace';
```
### Посмотреть какие индексы находятся в табличном пространстве
```
select * from pg_indexes where tablespace = 'ИМЯ_tablespace';
```
### Имя самой большой таблицы
```
SELECT relname, relpages FROM pg_class ORDER BY relpages DESC LIMIT 1;
relname — имя таблицы, индекса, представления и т.п.
relpages — размер представления этой таблицы на диске в количествах страниц (по умолчанию одна страницы равна 8 Кб).
pg_class — системная таблица, которая содержит информацию о связях таблиц базы данных.
```
	
