# Stream replication
```
mkdir /data
chown -R postgres:postgres /data
su - postgres -c "/usr/pgsql-10/bin/initdb -D /data"

firewall-cmd --zone=public --add-port=5433/tcp --permanent
firewall-cmd --reload
setenforce 0



nano /etc/systemd/system/postgresql.service
[Unit]
Description=PostgreSQL 10 database server
Documentation=https://www.postgresql.org/docs/10/static/
After=syslog.target
After=network.target

[Service]
Type=notify
User=postgres
Group=postgres
Environment=PGDATA=/data
OOMScoreAdjust=-1000
Environment=PG_OOM_ADJUST_FILE=/proc/self/oom_score_adj
Environment=PG_OOM_ADJUST_VALUE=0
ExecStartPre=/usr/pgsql-10/bin/postgresql-10-check-db-dir /data
ExecStart=/usr/pgsql-10/bin/postgres -D /data
ExecReload=/bin/kill -HUP $MAINPID
KillMode=mixed
KillSignal=SIGINT
TimeoutSec=0

[Install]
WantedBy=multi-user.target


Правки on master
nano /data/postgresql.conf
wal_level = hot_standby
listen_addresses = '*' 
max_wal_senders = 4 
wal_keep_segments = 100
synchronous_commit = local
synchronous_standby_names = '*'




psql -c "CREATE USER replicate REPLICATION LOGIN CONNECTION LIMIT 3 ENCRYPTED PASSWORD 'replicate';"
nano /data/pg_hba.conf
host    all replicate               192.168.1.21/32                 trust
```

### ON SLAVE
```
ON SLAVE
Systemctl stop postgresql
Mv /db/pg_data_dir/postgresql/10/main /db/pg_data_dir/postgresql/10/main-old
pg_basebackup -h 10.0.23.116 -R -P -U replication -D /db/pg_data_dir/postgresql/10/main -X stream;
-D /db/pg_data_dir/postgresql/10/main – куда восстановить
SHOW data_directory;
 поможет
su - postgres -c "pg_basebackup --host=192.168.1.20 --username=replicate --pgdata=/data --wal-method=stream"
nano /data/postgresql.conf
hot_standby = on 

systemctl start postgresql
create db testdb;
on slave
\l
```

### KEEPALIVED
```
# ubuntu 18
https://github.com/imlxh/pgsql11-ha-with-keepalived
add virtual ip - 10.0.23.118/24


export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales





# SCRIPT
mkdir -p /opt/scripts/keepalived/
mkdir -p /var/log/keepalived
nano /opt/scripts/keepalived/pg_checkstatus.sh
chmod 777 /opt/scripts/keepalived/pg_checkstatus.sh
#!/usr/bin/env bash
#SELECT name, setting FROM pg_settings WHERE category = 'File Locations';

export LANG=en_US.UTF-8
export PGPORT=5432
export PGUSER=pgmonitor
export PGDBNAME=pgmonitor
export PGHOME=/usr
export PGDATA=/db/pg_data_dir/postgresql/10/main
export PATH=$PGHOME/bin:$PATH

LOGFILE=/var/log/keepalived/keepalived_pg.log

SQL1='SELECT pg_is_in_recovery from pg_is_in_recovery();'
SQL2='update cluster_status set last_alive = now() where id = 1;'
#SQL3='SELECT 1;'

DB_ROLE=`echo $SQL1  |$PGHOME/bin/psql -d $PGDBNAME -U $PGUSER -At -w`

if [ $DB_ROLE == 't' ] ; then
    echo -e `date +"%F %T"` "`basename $0`: [INFO] PostgreSQL is running in STANDBY mode." >> $LOGFILE
        exit 0
elif [ $DB_ROLE == 'f' ]; then
    echo -e `date +"%F %T"` "`basename $0`: [INFO] PostgreSQL is running in PRIMARY mode." >> $LOGFILE
fi

# If current server is in STANDBY mode, then exit. Otherwise, update the cluster_status table. 

#echo $SQL3 |$PGHOME/bin/psql -p $PGPORT -d $PGDBNAME -U $PGUSER -At -w &> /dev/null
echo $SQL2 |$PGHOME/bin/psql -p $PGPORT -d $PGDBNAME -U $PGUSER -At -w
if [ $? -ne 0 ] ;then
    echo -e `date +"%F %T"` "`basename $0`: [ERR] Cannot update 'cluster_status' table, is PostgreSQL running?" >> $LOGFILE
    exit 1
#else
#    echo -e `date +"%F %T"` "`basename $0`: [INFO] Table 'cluster_status' is successfully updated." >> $LOGFILE
#    exit 0
fi

# DB CHANGES
su - postgres
psql -U postgres
create role pgmonitor superuser nocreatedb nocreaterole noinherit login encrypted password 'pgmonitor';
create database pgmonitor with template template0 encoding 'UTF8' owner pgmonitor;
\c pgmonitor pgmonitor
create schema pgmonitor;
create table cluster_status (id int unique default 1, last_alive timestamp(0) without time zone);

CREATE FUNCTION cannt_delete ()
    RETURNS trigger
    LANGUAGE plpgsql AS $$
    BEGIN
    RAISE EXCEPTION 'You can not delete!';
    END; $$;

CREATE TRIGGER cannt_delete BEFORE DELETE ON cluster_status FOR EACH ROW EXECUTE PROCEDURE cannt_delete();
CREATE TRIGGER cannt_truncate BEFORE TRUNCATE ON cluster_status FOR STATEMENT EXECUTE PROCEDURE cannt_delete();

insert into cluster_status values (1, now());
\q

nano /etc/postgresql/10/main/pg_hba.conf
local   all             pgmonitor                                 peer
host    all             pgmonitor       127.0.0.1/32            trust




# RELOAD CONF
SELECT pg_reload_conf();



install
sudo apt-get install keepalived -y
systemctl enable --now keepalived
nano /etc/sysctl.conf
net.ipv4.ip_forward=1
sysctl -p

# MASTER
nano /etc/keepalived/keepalived.conf
vrrp_script check_pg_status {
    script "/opt/scripts/keepalived/pg_checkstatus.sh"
    interval 6
    fall 3                  # require 3 failures for KO
    user root root
}

vrrp_instance VI_1 {
    interface ens160
    state MASTER
    priority 101
    virtual_router_id 101
    advert_int 1
    virtual_ipaddress {
        10.0.23.118/24
    }

    track_script {
        check_pg_status
    }

    authentication {
        auth_type PASS
        auth_pass AaQwer123
    }
}

systemctl restart keepalived
systemctl status keepalived
# SLAVE
nano /etc/keepalived/keepalived.conf
vrrp_script check_pg_status {
    script "/opt/scripts/keepalived/pg_checkstatus.sh"
    interval 6
    fall 3                  # require 3 failures for KO
    user root root
}

vrrp_instance VI_1 {
    state BACKUP
    interface ens160
    priority 100
    virtual_router_id 101
    advert_int 1
    virtual_ipaddress {
        10.0.23.118/24
    }
    track_script {
        check_pg_status
    }
	
    authentication {
        auth_type PASS
        auth_pass AaQwer123
    }
}

systemctl restart keepalived
systemctl status keepalived

# notes
!Указывает на то что в каком состоянии стартует нода
state MASTER
!Интерфейс для виртуальных IP
interface ens18
!Интерфейс для обмена служебными пакетами между нодами
lvs_sync_daemon_inteface ens18
!Уникальное имя виртуального роутера should be same on both MASTER/SLAVE servers.
virtual_router_id 102
!Приоритет данной ноды относительно других, нода с наибольшим приоритетом переходит в состояние MASTER
priority 150
!Как часто происходит обновление состояния кластера
advert_int 1
!Аутентификация используется для синхронизации между нодами
authentication {
        auth_type PASS
        auth_pass 12345678
}
!Виртуальные адреса, которые настроит keealived
virtual_ipaddress {
        192.168.135.237/24
}


# LANGUAGE PERL ERROR
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales
locale-gen en_US.UTF-8

```
