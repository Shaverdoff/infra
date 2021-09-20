# README Commands
```
# Подключение к БД	
mongo --port 27017

# Список пользователей
use admin;
db.getUsers()

Создаем пользователя для подключения:
Подключаемся к бд
mongo --port 27017
use admin
db.createUser(
  {
    user: "myUserAdmin",
    pwd: "abc123",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)
SUPERUSER
use admin
db.createUser(
    {
      user: "dba",
      pwd: "12345",
      roles: [ "root" ]
    }
)
ИЛИ через COMPASS - Можно скачать для WINDOWS
Смена пароля
use log
db.updateUser(
   "admin",
   {
      pwd: "321wed"
   }
)

Удаление пользователя
db.dropUser("admin")

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
