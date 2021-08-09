# BITRIX24
## Пользователи
### Создаем юзера
Администрирование => Пользователи => Список пользователей => Подразделение и выбираем нужное

Он появляется в CRM=> Сотрудники в нужном отделе

В CRM => Настройки => Права доступа правим права отдела

заходим под юзером и тестим
## BACKUP/RESTORE
### BACKUP
Делается на самом сайте в GUI
### RESTORE
<https://corp-dev.company.ru/restore.php>

даем ему архив

если белая страница

tail -f /var/log/httpd/corp-dev\_error\_log

PHP Fatal error:  Allowed memory size of 268435456 bytes exhausted (tried to allocate 264257536 bytes) in /home/bitrix/ext\_www/corp-dev.company.ru/restore.php

nano /home/bitrix/www/.htaccess

php\_value memory\_limit 512M

или

nano /etc/php.d/bitrixenv.ini

memory\_limit = 512M

отображение ошибок

php\_value display\_errors 1
## ERROR
### Could not start session by PHP
cd /etc/php-fpm.d

grep -r 'session.save\_path' .

chmod -R 0777 /var/lib/php/session/

chmod -R 0777 /tmp/php\_sessions/www
## BITRIX CAPTCHA
Администрирование Настройки Настройка продукта CAPTCHA

отключение для юзеров

Администрирование Группы Мои сотрудники Настройки безопасность - CAPTCHA - Не предопределять для бесконечного

изменить требования к паролю 

в группах/ безопасность

не забывать что группы имеют свои требования к паролю и если юзер в нескольких группах то они пересекаются и юзер блочится

в главном модуле "Использовать Captcha при регистрации".

В настройках групп пользователей на вкладке "Безопасность", напротив надписи "Количество попыток ввода пароля до показа CAPTCHA:" установлена галка "Не переопределять".
## При создании лида были проблемы без прав админа
Решения:

- Ошибку вызывало отсутствие aрi модуля, после его установки пользователь может работать с CRM
- были не корректно установлены права на файлы ядра. 
  Проверить права доступа к файлам, если необходимо, можно в административной панели на вкладке:

![https://cp.bitrix.ru/bitrix/services/main/ajax.php?action=disk.api.file.showImage&humanRE=1&fileId=3995048&fileName=image+%282%29.png&livechat\_auth\_id=eab2e02f31079a693e7f8aca4b62d7e9&livechat\_user\_id=710129](Aspose.Words.fe895da4-acf5-4a8e-b413-79c9d6b93733.001.png)


## Врубить режим админа
Заходим

Жмем по себе справа вверху открывается меню

Где фото вверху Администратор – жмем на него – Включить режим Админа
## #disable https
\# for disable ssl redirect

rm /home/bitrix/www/.htsecure

then reboot server bitrix

done
## Создание прав доступа
Заходим

Ищем CRM в левом меню

Настройки/Права/Права доступа

Справа Список ролей – жмем добавить

Настраиваем роль

Присвоение роли

В левом столбике 

Добавить право доступа (можно добавить группе, пользователю или отделу)
## Забрать права админа
Сотрудники/Профиль/Дествия на фото – забрать права админа

## UPDATE BITRIX SERVER
Подключаемся к серверу

Подключаемся к root

Выбираем Manage localhost

Update server
## GET FREE CERTS FOR BITRIX24 on server

login on server under root

in menu Bitrix

select 

\8. Manage pool web servers

\3. Configure certificates

\1. Configure "Let's encrypt" certificate

Enter site name (default): 

default

Enter DNS name(s): 

btx.vko-simvol.ru

Enter email for "Let's encrypt" notifications: 

bitrix@vko-simvol.ru


Не забыть настроить доступ портов 80 и 443 на роутере
## Bitrix push and pull
\# INSTALL ON BITRIX 7.4-3 PUSH AND PULL

\#  

\# check on server working push&pull

yum install telnet

telnet localhost 8895

\# check hostname

btx.vko-simvol.ru

заходим в меню битрикса

9 Configure Push/RTC service for the pool

1 Install/Update NodeJS RTC service

Enter hostname or 0 to exit: btx.vko-simvol.ru

Please confirm you want to update NginxStreamModule to NodeJS Push on the server btx.vko-simvol.ru(Y|n) Y

\# OTVET

Start task:

JobID     : pushserver\_8142084115

PID       : 21818

Status    : running

It will run 'Configure NodeJS Push Service on btx.vko-simvol.ru' in the pool

\# HOW CHECK

GO in BITRIX MENU

press 10 Background pool tasks > 1. View running tasks


\# GO ON SITE

Рабочий стол -> Настройки -> Настройки продукта -> Настройки модулей -> Push and Pull
## Update mysql and php version
Create Management pool
click Manage servers in the pool

Update PHP and MySQL

Update PHP to version 7.2
### ERROR
The GPG keys listed for the "Percona-Release YUM repository - x86\_64" repository are already installed but they are not correct for this package.

Check that the correct key URLs are configured for this repository.

sudo yum update percona-release

sudo yum update percona-release
# COUCHBASE
For Enterprise need minimum 4gb RAM.
## why no community
Because community does not have native encryption and self geo replication
## Failed to start couchbase-server.service: Unit couchbase-server.service is masked
sudo systemctl unmask couchbase-server

sudo systemctl start couchbase-server
## Pre-install
\# disable swap

sudo swapoff -a

\# install packages

apt-get install python python-minimal  libpython-stdlib  python-httplib2  libpython2.7-stdlib  libpython2.7-minimal python2.7 python2.7-minimal
## Install
\# DOWNLOAD PKG from site and install it (minimum 3 servers node)

https://www.couchbase.com/downloads/thankyou/enterprise?product=couchbase-server&version=6.0.3&platform=ubuntu-18.04&addon=false&beta=false 

sudo apt-get update

sudo dpkg -i couchbase-server-enterprise\_6.0.3-ubuntu18.04\_amd64.deb 

sudo apt-get -f install

You have successfully installed Couchbase Server.

Please browse to http://somadb:8091/ to configure your server.

\# IF INSTALLED UFW

#sudo ufw allow from any to any port 4369,8091:8094,9100:9105,9998,9999,11209:11211,11214,11215,18091:18093,21100:21299 proto tcp


Warning: Transparent hugepages looks to be active and should not be.

Please look at https://developer.couchbase.com/documentation/server/current/install/thp-disable.html as for how to PERMANENTLY alter this setting

\# check this

cat /sys/kernel/mm/transparent\_hugepage/enabled

always [madvise] never

cat /sys/kernel/mm/transparent\_hugepage/defrag

always defer defer+madvise [madvise] never

\# create new service

nano /etc/init.d/disable-thp

#!/bin/bash

\### BEGIN INIT INFO

\# Provides:          disable-thp

\# Required-Start:    $local\_fs

\# Required-Stop:

\# X-Start-Before:    couchbase-server

\# Default-Start:     2 3 4 5

\# Default-Stop:      0 1 6

\# Short-Description: Disable THP

\# Description:       disables Transparent Huge Pages (THP) on boot

\### END INIT INFO

case $1 in

start)

`  `if [ -d /sys/kernel/mm/transparent\_hugepage ]; then

`    `echo 'never' > /sys/kernel/mm/transparent\_hugepage/enabled

`    `echo 'never' > /sys/kernel/mm/transparent\_hugepage/defrag

`  `elif [ -d /sys/kernel/mm/redhat\_transparent\_hugepage ]; then

`    `echo 'never' > /sys/kernel/mm/redhat\_transparent\_hugepage/enabled

`    `echo 'never' > /sys/kernel/mm/redhat\_transparent\_hugepage/defrag

`  `else

`    `return 0

`  `fi

;;

esac

\# start service

chmod 755 /etc/init.d/disable-thp

sudo update-rc.d disable-thp defaults

service disable-thp start

systemctl status disable-thp

## WEB SETTINGS
Create New Cluster

http://208.117.85.108:8091/ui/index.html

Setup new claster



Admin/QWE123qwe

Click Next

Click Configure

You can use only 80% of RAM !!!



Join to existing cluster

http://208.117.84.17:8091/ui/index.html

Click join to existing cluster

Cluster Hostname/IP – set the ip first server of cluster

Username/Password – set the creds from first server of cluster

This Node: IP – set ip of this server 

Then Click REBALANCE
### Create Bucket
Click Buckets in main menu

Choice type of bucket (Memcached, Couchbase or etc)

Select Couchbase bucket type
### Create User
Click Security in main menu and press Add User

Set username/password and give some roles.
### Auto-Failover
Settings → Node Avability → Failover Nodes Automatically → Enable auto-failover.
### SYNC GATEWAY
Create bucket with disabled replica

Create user sync\_gateway  with roles:

Read-only Admin

- Bucket Admin on created bucket
- Query and Index Services / Query Manage Index
- Query and Index Services / Query Select
- Data service / Data DCP READER

Server config

\# install

wget http://packages.couchbase.com/releases/couchbase-sync-gateway/2.6.1/couchbase-sync-gateway-enterprise\_2.6.1\_x86\_64.deb

dpkg -i couchbase-sync-gateway-enterprise\_2.6.1\_x86\_64.deb

\# move old config for backup

mv /home/sync\_gateway/sync\_gateway.json /home/sync\_gateway/sync\_gateway.json.old

nano /home/sync\_gateway/sync\_gateway.json

{

`  `"adminInterface": "0.0.0.0:4985",

`  `"interface": "0.0.0.0:4984", 

`  `"log": ["\*"],

`  `"databases": {

`    `"mydb": {

`      `"server": "http://localhost:8091",

`      `"bucket": "sync\_gateway",

`      `"username": "sync\_gateway",

`      `"password": "QWE123qwe",

`      `"enable\_shared\_bucket\_access": true, 

`      `"import\_docs": "continuous",

`      `"num\_index\_replicas": 0, 

`      `"users": {

`        `"GUEST": { "disabled": false, "admin\_channels": ["\*"] }

`      `},

`      `"sync": `function (doc, oldDoc) {

`        `if (doc.sdk) {

`          `channel(doc.sdk);

`        `}

`      `}`

`    `}

`  `}

}

To stop/start the sync\_gateway service, use the following.

systemctl stop sync\_gateway

systemctl start sync\_gateway

systemctl status sync\_gateway

\# service running on

http://localhost:4985/\_admin/

