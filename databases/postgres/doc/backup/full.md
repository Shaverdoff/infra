# FULL BACKUP
```
1 # create directory for archive logs
sudo -H -u postgres mkdir /var/lib/pgsql/10/pg_log_archive

2 # enable archive logging
nano /var/lib/pgsql/10/data/postgresql.conf
  wal_level = replica
  archive_mode = on
  archive_command = 'test ! -f /var/lib/pgsql/10/pg_log_archive/%f && cp %p /var/lib/pgsql/10/pg_log_archive/%f'

3 # restart cluster
systemctl restart postgresql-10

4 # create database with some data
sudo su - postgres

psql -c "create database test;"
psql test -c "
create table posts (
  id integer,
  title character varying(100),
  content text,
  published_at timestamp without time zone,
  type character varying(100)
);
insert into posts (id, title, content, published_at, type) values
(100, 'Intro to SQL', 'Epic SQL Content', '2018-01-01', 'SQL'),
(101, 'Intro to PostgreSQL', 'PostgreSQL is awesome!', now(), 'PostgreSQL');
"

5 # archive the logs
psql -c "select pg_switch_wal();" # pg_switch_xlog(); for versions < 10

6 # backup database
pg_basebackup -Ft -D /var/lib/pgsql/10/db_file_backup

7 # stop DB and destroy data
sudo systemctl stop postgresql-10
rm -rf /var/lib/pgsql/10/data/*
ls /var/lib/pgsql/10/data/

8 # restore
tar xvf /var/lib/pgsql/10/db_file_backup/base.tar -C /var/lib/pgsql/10/data/
tar xvf /var/lib/pgsql/10/db_file_backup/pg_wal.tar -C /var/lib/pgsql/10/data/pg_wal/

9 # add recovery.conf
nano /var/lib/pgsql/10/data/recovery.conf
restore_command = 'cp /var/lib/pgsql/10/pg_log_archive/%f %p'
chown postgres:postgres -R /var/lib/pgsql/10/data/recovery.conf

10 # start DB
sudo systemctl start postgresql-10
cat /var/lib/pgsql/10/data/recovery.done
Появится recovery.done

11 # verify restore was successful
su - postgres
psql test -c "select * from posts;"
```
