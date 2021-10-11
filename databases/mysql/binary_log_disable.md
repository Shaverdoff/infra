### SIZE OF DATABASE
```
SELECT *
FROM (SELECT table_schema AS DB Name,
ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) AS DB Size in MB
FROM information_schema.tables
GROUP BY DB Name) AS tmp_table
ORDER BY DB Size in MB DESC;
```
###
```
SELECT table_schema "Database_Name"
SUM(data_length + index_length) / (1024 * 1024) "Database Size in MB"
FROM information_schema.TABLES
GROUP BY table_schema;
```
SELECT table_schema "Database (table_schema)", sum((data_length+index_length)/1024/1024/1024) AS "DB size in GB" FROM information_schema.tables WHERE table_schema = "$DATABASE";
# DISABLE LOG
```
select @@binlog_expire_logs_seconds;
# show existing logs
SHOW BINARY LOGS;
# disable expire_logs_days
show variables like 'expire_logs_days';
set global expire_logs_days=0;
SET GLOBAL binlog_expire_logs_seconds = 600;
# delete old logs
flush binary logs;
SHOW BINARY LOGS;
SHOW VARIABLES LIKE 'log_bin';
```
