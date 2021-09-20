# README Commands
```
# Подключение к БД	
mongo --port 27017

# Останов БД	mongo --port 27017
use admin
db.shutdownServer()

# Список БД
show dbs
# Использовать БД
use db

# REPAIR БД	
mongod --dbpath /var/lib/mongodb --repair
```
