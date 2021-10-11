### SIZE OF DATABASE
```
SELECT table_schema "Database (table_schema)", sum((data_length+index_length)/1024/1024/1024) AS "DB size in GB" FROM information_schema.tables WHERE table_schema = "emarsys";
```
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
