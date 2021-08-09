```
Backup your databases
docker exec -t confluence-db pg_dumpall -c -U postgres > dump_conflu.sql
docker exec -it confluence-db bash
cd /var/lib/pgsql/data
pg_dumpall -c -U postgres > dump_conflu.sql
Restore your databases
cat your_dump.sql | docker exec -i your-db-container psql -U postgres


SELECT pg_size_pretty(pg_database_size('confluence'));

docker-compose stop
# Restore
mv /data/confluence-db /data/confluence-db-old
mkdir /data/confluence-db


# copy old backup
cp /data/confluence-db-old/dump_conflu.sql /data/confluence-db/
chmod -R 777 /data/confluence-db/

#change postgres version
cd /etc/docker/confluence/
# comment confluence and change postgres image version
nano docker-compose.yml

docker-compose pull confluence-db
docker-compose up -d confluence-db
docker exec -it confluence-db bash
cd /var/lib/pgsql/data/
psql -f dump_conflu.sql postgres
exit

# uncomment all config in docker-compose.yml
docker-compose up -d --force-recreate


then
docker-compose stop
# change confluence version to 7.7.2
docker-compose up -d --force-recreate
```