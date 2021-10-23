```
4.1	Установка
Должны быть установлены пакеты
MariaDB-common-10.5.4-1.el8.x86_64
MariaDB-server-10.5.4-1.el8.x86_64
MariaDB-shared-10.5.4-1.el8.x86_64
MariaDB-client-10.5.4-1.el8.x86_64
python3-PyMySQL-0.8.0-10.module_el8.1.0+245+c39af44f.noarch


curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash
dnf install MariaDB-client MariaDB-server python3-PyMySQL
systemctl enable --now mariadb
firewall-cmd --add-port=3306/tcp --permanent
firewall-cmd --reload

Installing dependencies:
 MariaDB-common                      x86_64               10.5.5-1.el8                                       mariadb-main                87 k
 MariaDB-shared                      x86_64               10.5.5-1.el8                                       mariadb-main               116 k
 boost-program-options               x86_64               1.66.0-7.el8                                       AppStream                  140 k
 galera-4                            x86_64               26.4.5-1.el8                                       mariadb-main                13 M
 perl-DBI                            x86_64               1.641-3.module_el8.1.0+199+8f0a6bbd                AppStream                  740 k
 perl-Math-BigInt                    noarch               1:1.9998.11-7.el8                                  BaseOS                     196 k
 perl-Math-Complex                   noarch               1.59-416.el8                                       BaseOS                     108 k
 rsync                               x86_64               3.1.3-7.el8                                        BaseOS                     404 k
 socat                               x86_64               1.7.3.3-2.el8                                      AppStream                  302 k
Enabling module streams:
 perl                                                     5.26                                                                               
 perl-DBI                                                 1.641                                                                              
Code Block 12 Зависимости
4.2	Конфигурация сервера
Запустить скрипт mysql_secure_installation. На следующие вопросы ответить утвердительно:
Установить пароль root, удалить anonymous users, удалить тестовую БД
На мастере отредактировать файл конфигурации, подставить значения
{{ master_ipv4.address }}
{{ mysql_master_innodb_buffer_pool_size }} выбрать из расчета имеющейся RAM
[mysqld]
datadir = /var/lib/mysql
bind-address = {{ master_ipv4.address }}
port = 3306
socket = /var/lib/mysql/mysql.sock
max_connections = 150
innodb_buffer_pool_size = {{ mysql_master_innodb_buffer_pool_size }}
character-set-server = utf8
default-authentication-plugin = mysql_native_password
 
server-id = 1
log-bin = mysql-bin
binlog_do_db = sberdisk
 
[mysqld_safe]
log-error=/var/log/mariadb/mariadb.log
pid-file=/var/run/mariadb/mariadb.pid
Code Block 13 /etc/my.cnf
На слейве отредактировать файл конфигурации, подставить значения
{{ slave_ipv4.address }}
{{ mysql_slave_innodb_buffer_pool_size }} выбрать из расчета имеющейся RAM
[mysqld]
datadir = /var/lib/mysql
bind-address = {{ slave_ipv4.address }}
port = 3306
socket = /var/lib/mysql/mysql.sock
max_connections = 150
innodb_buffer_pool_size = {{ mysql_slave_innodb_buffer_pool_size }}
character-set-server = utf8
default-authentication-plugin = mysql_native_password
 
server-id = 2
log-bin = mysql-bin
binlog_do_db = sberdisk
 
[mysqld_safe]
log-error=/var/log/mariadb/mariadb.log
pid-file=/var/run/mariadb/mariadb.pid
Code Block 14 /etc/my.cnf
Отредактировать файл /root/.my.cnf на обеих нодах и поместить туда пароль root, созданный при запуске скрипта
[client]
user=root
password={{ mysql_root_password }}
socket=/var/lib/mysql/mysql.sock
Code Block 15 /root/.my.cnf
chmod 600 /root/.my.cnf
Code Block 16 Отредактировать права
4.3	Перенос данных на отдельный диск
systemctl stop mariadb
mv /var/lib/mysql /data/mysql && ln -s /data/mysql /var/lib
systemctl start mariadb
4.4	Добавление пользователей
На мастере авторизоваться в mysql под root и выполнить следующие команды, заменив переменные
{{ user_password }}
{{ slave_ip4_address }}
{{ replication_password }}
{{ maxscale_password }}
на  соответствующие значения
CREATE DATABASE sberdisk;
CREATE USER 'user'@'%' IDENTIFIED BY '{{ user_password }}';
CREATE USER 'replicator'@'{{ slave_ip4_address }}' IDENTIFIED BY '{{ replication_password }}';
CREATE USER 'maxscale'@'%' IDENTIFIED BY '{{ maxscale_password }}';
GRANT ALL PRIVILEGES ON sberdisk.* TO 'user'@'%';
GRANT REPLICATION SLAVE ON *.* to 'replicator'@'{{ slave_ip4_address }}';
GRANT SELECT ON mysql.user TO 'maxscale'@'%';
GRANT SELECT ON mysql.roles_mapping TO 'maxscale'@'%';
GRANT SELECT ON mysql.db TO 'maxscale'@'%';
GRANT SELECT ON mysql.tables_priv TO 'maxscale'@'%';
GRANT BINLOG MONITOR on *.* to maxscale;
GRANT SHOW DATABASES on *.* to maxscale;
GRANT REPLICATION SLAVE ADMIN on *.* to maxscale;
4.5	Настройка репликации
mysql -e 'USE sberdisk;FLUSH TABLES WITH READ LOCK;'
mysqldump  --all-databases > /tmp/migration_dump.sql
mysql -e 'USE sberdisk;UNLOCK TABLES;'
Code Block 17 Создание дампа на мастере
Скопировать на слейв.
mysql -e "STOP SLAVE;"
mysql < /tmp/migration_dump.sql
Code Block 18 Восстановление на слейве
На слейве создать пользователя. Указать пароль вместо {{ user_password }}
CREATE USER 'user'@'%' IDENTIFIED BY '{{ user_password }}';
GRANT ALL PRIVILEGES ON sberdisk.* TO 'user'@'%';
На мастере выполнить и сохранить полученные значения для подстановки в {{ current_log_master }} и {{ current_pos_master }} соответственно
mysql -e 'SHOW MASTER STATUS;' | grep -v File | awk '{print $1}'
mysql -e 'SHOW MASTER STATUS;' | grep -v File | awk '{print $2}'
На слейве выполнить, указав значения для переменных
{{ master_ip }}
{{ replication_pass }}
{{ current_log_master }}
{{ current_pos_master }}
mysql -e "CHANGE MASTER TO MASTER_HOST='{{ master_ip }}', MASTER_USER='replicator', MASTER_PASSWORD='{{ replication_pass }}', MASTER_LOG_FILE='{{ current_log_master }}', MASTER_LOG_POS={{ current_pos_master }};"
mysql -e "START SLAVE;"
mysql -e "SHOW SLAVE STATUS\G;"
Последняя команда должна содержать  указание  на корректность работы слейва:
 Slave_SQL_Running_State: Slave has read all relay log; waiting for more updates

```
