# Таблицы
### наполнение таблиц
```
SELECT * FROM t_random2;
create table t_random5 as select s, md5(random()::text) from generate_Series(1,500000) s;
```
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
