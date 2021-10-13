Change Standalone to WiredTiger
migrate from MMAP to WIRETIGER storage engine
```
1) Create backup of existing DB
mongodump --out=<exportDataDestination>
2) shutdown your mongo and change --storageEngine to wiredTiger 
systemctl stop mongod
## Update configuration for WiredTiger.
## Remove any MMAPv1 Specific Configuration Options from the mongod instance configuration.
nano /etc/mongo.conf
3) mongod with WiredTiger will not start with data files created with a different storage engine.
mv /var/lib/mongo /var/lib/mongo_backup
mkdir /var/lib/mongo
systemctl start mongod
4) restore backup
mongorestore <exportDataDestination>
```
