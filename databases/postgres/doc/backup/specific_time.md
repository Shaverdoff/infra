# BACKUP to specific time
```
1 # backup database and gzip
pg_basebackup -Ft -X none -D - | gzip > /var/lib/pgsql/10/db_file_backup.tar.gz

2 # wait
psql test -c "insert into posts (id, title, content, type) values
(102, 'Intro to SQL Where Clause', 'Easy as pie!', 'SQL'),
(103, 'Intro to SQL Order Clause', 'What comes first?', 'SQL');"

Check timezone
psql show timezone;
Asia/Yekaterinburg

3 # archive the logs
psql -c "select pg_switch_wal();" # pg_switch_xlog(); for versions < 10

4 # stop DB and destroy data
sudo systemctl stop postgresql-10
rm -rf /var/lib/pgsql/10/data/*
ls /var/lib/pgsql/10/data/

5 # restore
tar xvfz /var/lib/pgsql/10/db_file_backup.tar.gz -C /var/lib/pgsql/10/data/

6 # add recovery.conf
nano /var/lib/pgsql/10/data/recovery.conf
restore_command = 'cp /var/lib/pgsql/10/pg_log_archive/%f %p'
recovery_target_time = '2018-06-09 12:50:00 Asia/Yekaterinburg'
chown postgres:postgres -R /var/lib/pgsql/10/data/recovery.conf

7 # start DB
sudo systemctl start postgresql-10

8 # verify restore was successful
cat /var/lib/pgsql/10/data/recovery.done
su - postgres
psql test -c "select * from posts;"
tail -n 100 /var/lib/pgsql/10/data/log/*.log

9 # complete and enable database restore
psql -c "select pg_wal_replay_resume();"
```
