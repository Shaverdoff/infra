# Как найти медленные запросы в POSTGRES DB - установить опцию отслеживания медленных запросов больше 5мс для конкретной бд
```
# FOR specific DB
ALTER DATABASE tezis SET log_min_duration_statement = 7000;
\c tezis
SELECT pg_sleep(10);
```
