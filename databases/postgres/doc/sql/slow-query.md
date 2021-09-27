# Как найти медленные запросы в POSTGRES DB - установить опцию отслеживания медленных запросов больше 5мс для конкретной бд
```
# FOR specific DB
ALTER DATABASE tezis SET log_min_duration_statement = 7000;
\c tezis
SELECT pg_sleep(10);
```
# Завершение зависших процессов
```
https://medium.com/@alukyanov.dev/postgresql-%D0%BD%D0%B0%D0%B9%D1%82%D0%B8-%D0%B8-%D1%83%D0%BD%D0%B8%D1%87%D1%82%D0%BE%D0%B6%D0%B8%D1%82%D1%8C-%D0%B7%D0%B0%D0%B2%D0%B8%D1%81%D1%88%D0%B8%D0%B5-%D0%B7%D0%B0%D0%BF%D1%80%D0%BE%D1%81%D1%8B-65b9517e5711

SELECT pid, 
now() - pg_stat_activity.query_start AS duration, 
query, 
state
FROM pg_stat_activity
WHERE (now() - pg_stat_activity.query_start) > interval '4 hour'

Ответ
{"pid"=>"19736", "duration"=>"22:24:27.199454", "query"=>"SELECT 1", "state"=>"idle"}
•	pid — ID дочернего процесса PG, выполняющего запрос.
•	duration — сколько времени уже выполняется запрос
•	query — сам запрос

•	pg_cancel_backend — “мягкий” вариант завершения процесса, шлётся SIGINT
•	pg_terminate_backend — “жёсткий” вариант, шлётся SIGTERM
SELECT pg_cancel_backend(19736);
SELECT pg_terminate_backend(19736);
```
