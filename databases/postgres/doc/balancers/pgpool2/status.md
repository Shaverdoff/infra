# Настройка количества соединений
```
https://www.pgpool.net/mediawiki/index.php/Relationship_between_max_pool,_num_init_children,_and_max_connections
```
# PGPOOL STATUS
```
PG_BACKEND_NODE_LIST=0:pg01.localnet:5432:1:/var/lib/pgsql/10/data:DISALLOW_TO_FAILOVER,1:pg02.localnet:5432:1:/var/lib/pgsql/10/data:DISALLOW_TO_FAILOVER
Проверить состояние можно следующими способами:
На одном из серверов, который в результате выборов стал мастером, должен появиться новый сетевой интерфейс с адресом указанным в параметре delegate_IP конфига pgpool.conf
Подключившись через pgpool можно посмотреть состояние балансировки запросов - show pool_nodes;
pgpool сохраняет состояние каждого сервера БД в файл /tmp/pgpool_status. В случае если сервер БД доступен, а pgpool считает что нет, 
то достаточно этот файл удалить и перезапустить pgpool. Либо сделать это через интерфейс PCP
```
