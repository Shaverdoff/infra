```
CREATE USER 'instana'@'%' IDENTIFIED BY 'QWE123qwe';
grant all privileges on *.* to 'instana'@'%';
GRANT SELECT ON PERFORMANCE_SCHEMA.* TO 'instana'@'%';
GRANT REPLICATION CLIENT ON *.* TO 'instana'@'%';
GRANT SELECT ON performance_schema.events_waits_summary_global_by_event_name TO 'instana'@'%';
GRANT SELECT ON performance_schema.events_statements_summary_by_digest TO 'instana'@'%';
GRANT SELECT ON performance_schema.events_statements_summary_global_by_event_name TO 'instana'@'%';
flush privileges;
```
