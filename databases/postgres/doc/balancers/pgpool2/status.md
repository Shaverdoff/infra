# Настройка количества соединений
```
https://www.pgpool.net/mediawiki/index.php/Relationship_between_max_pool,_num_init_children,_and_max_connections
```
# PGPOOL STATUS
```
PG_BACKEND_NODE_LIST=0:pg01.localnet:5432:1:/var/lib/pgsql/10/data:DISALLOW_TO_FAILOVER,1:pg02.localnet:5432:1:/var/lib/pgsql/10/data:DISALLOW_TO_FAILOVER
Проверить состояние можно следующими способами:
1) На одном из серверов, который в результате выборов стал мастером, должен появиться новый сетевой интерфейс с адресом указанным в параметре delegate_IP конфига pgpool.conf
2) pgpool сохраняет состояние каждого сервера БД в файл /tmp/pgpool_status. В случае если сервер БД доступен, а pgpool считает что нет, то достаточно этот файл удалить и перезапустить pgpool. Либо сделать это через интерфейс PCP.
3) Подключившись через pgpool можно посмотреть состояние балансировки запросов:
su - postgres
export PGPORT=9999
export PGDATA=/var/lib/pgsql/10/data
export PGHOSTADDR=10.19.88.253
psql
# exec for see who master
show pool_nodes;

# check balancer
select inet_server_addr (); 
select * from repl_nodes;
# check pool status
show pool_nodes;
show pool_pools;
select * from repl_nodes;
select * from pg_stat_replication;
OR PCP_* commands
pcp_pool_status
pcp_node_info -h localhost -U postgres 0

#check
su postgres
 pcp_node_info -U postgres -h 10.19.88.217 -n 0
 10.19.88.219 5432 3 0.500000 down standby

 
 # worked! attach node after failover
 pcp_attach_node 0
 pcp_attach_node 1
cat /tmp/pgpool_status
up
up

# or but need use another port 9898
pcp_attach_node -h 10.19.88.219 -p 5432 -w -n 0

# disable node number 0,1,2,3....etc
pcp_detach_node 1

```
