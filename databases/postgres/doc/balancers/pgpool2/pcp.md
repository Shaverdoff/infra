### Настройка PCP
```
Для удобства администрирования можно включить интерфейс PCP. Для этого нужно в /etc/pgpool-II/pcp.conf добавить логин и хеш пароля, который можно получить с помощью pg_md5 (pg_md5 -u логин -p). Причем в качестве логина выступает учетная запись из под которой будут запускаться pcp утилиты, например:

[root@p-pool-1 ~]# cat /etc/pgpool-II-96/pcp.conf|tail -n 1
postgres:4d818bd73521ece2c1e8710db8f2602c
[root@p-pool-1 ~]# su - postgres
[postgres@p-pool-1 ~]$ pcp_node_count
Password:
2
А вот так можно принудительно отключить или подключить сервера БД:
[postgres@p-pool-1 ~]$ pcp_detach_node 1
Password:
pcp_detach_node -- Command Successful
[postgres@p-pool-1 ~]$ cat /tmp/pgpool_status
up
down
[postgres@p-pool-1 ~]$ pcp_attach_node 1
Password:
pcp_attach_node -- Command Successful
[postgres@p-pool-1 ~]$ cat /tmp/pgpool_status
up
up
Важные особенности
При запуске pgpool забирает информацию о состоянии балансировки и статусе хостов БД со своей соседней ноды которая является мастером. Поэтому в случае когда PCP не настроен и необходимо "обнулить" информацию о статусе БД, то надо останавливать pgpool и удалять /tmp/pgpool_status не последовательно, а одновременно на всех нодах pgpool и только после этого их заново запускать
Тест
psql --port=5432 -c "show pool_nodes" --host=172.17.58.31
```
