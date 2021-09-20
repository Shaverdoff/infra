#BACKUP
```
# connect to db
mongo --port 27017
# show all databases
show dbs;
# exit from console
exit;
# backup
mongodump --db cl_352 --out /tmp/mongobackup_cl_352
```