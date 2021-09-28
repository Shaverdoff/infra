# Instana
### 
```
# PHP:
Агенту не важно, как запущено приложение в контейнере или нет, в любом случае он подключится к нему.
поэтому просто раскомментируем настройки в configuration.yml агента инстаны по php

# APACHE:
добавить блок статуса в апач httpd.conf
и расскоментить блок апача в конфиге инстана-агента configuration.yml
com.instana.plugin.httpd:
  tracing:
    enabled: true
    



# Memcached
расскоментить блок Memcached в configuration.yml

# MySQL:
### create user in db
CREATE USER 'instana'@'%' IDENTIFIED BY 'QWE123qwe';
grant all privileges on *.* to 'instana'@'%';
GRANT SELECT ON PERFORMANCE_SCHEMA.* TO 'instana'@'%';
GRANT REPLICATION CLIENT ON *.* TO 'instana'@'%';
GRANT SELECT ON performance_schema.events_waits_summary_global_by_event_name TO 'instana'@'%';
GRANT SELECT ON performance_schema.events_statements_summary_by_digest TO 'instana'@'%';
GRANT SELECT ON performance_schema.events_statements_summary_global_by_event_name TO 'instana'@'%';
flush privileges;

### uncomment things in configuration.yml
com.instana.plugin.mysql:
  user: 'instana'
  password: 'QWE123qwe'
#  schema_excludes: ['INFORMATION_SCHEMA', 'PERFORMANCE_SCHEMA']
#  sslTrustStore: '/path/to/truststore.jks'
#  sslTrustStorePassword: 'mysqlTsPassword'
#  sslKeyStore: '/path/to/sslKeyStoreFile.jks'
#  sslKeyStorePassword: 'mysqlKsPassword'
#  disableSslHostnameVerification: false

### Скачали mysql-connector-java-8.0.20.jar и положили в эту папку
/opt/instana/agent/deploy

и еще была проблема с 
```
