# RESTORE
```
# connect to db
mongo --port 27017
# show all databases
show dbs;
# switch to existing database
use cl_352;
# delete existing database
db.dropDatabase()
# exit from console
exit;
# restore
mongorestore --db cl_352 --verbose /tmp/mongobackup_cl_352/cl_352/

# Восстановление БД с авторизацией
mongorestore --host databasehost:98761 --username restoreuser --password restorepwd --authenticationDatabase admin --db targetdb ./path/to/dump/

```