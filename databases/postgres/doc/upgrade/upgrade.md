```
upgrade 10.3 to 12
UPGRADE 10.3 to 12
сначало устанавливаем 12 версию

sudo yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo yum -y install epel-release yum-utils
sudo yum-config-manager --enable pgdg12
sudo yum -y install postgresql12-server postgresql12 postgresql12-contrib


# INIT DB
sudo /usr/pgsql-12/bin/postgresql-12-setup initdb
sudo systemctl enable postgresql-12

# check 
su postgres
/usr/pgsql-12/bin/pg_upgrade -c -d /var/lib/pgsql/10/data/ -D /var/lib/pgsql/12/data/ -b /usr/pgsql-10/bin/ -B /usr/pgsql-12/bin/
-d - путь к старой базе
-D - путь к новой базе
-b - путь к старым бинари
-B - путь к новым бинари

выдаст файлик 
/data/pgsql/10/data/loadable_libraries.txt

ошибки в нем, например
could not load library "$libdir/uuid-ossp": ERROR:  could not access file "$libdir/uuid-ossp": No such file or directory
решение - установить их
sudo yum install pg_cron_12

Когда проверка все вернет ОК можно приступать к обновлению.

Останавливаем БД
systemctl stop postgresql-10.service
systemctl disable postgresql-10.service
su postgres
/usr/pgsql-12/bin/pg_upgrade -d /var/lib/pgsql/10/data/ -D /var/lib/pgsql/12/data/ -b /usr/pgsql-10/bin/ -B /usr/pgsql-12/bin/

# COPY CONFIGS
cp /var/lib/pgsql/10/data/pg_hba.conf /var/lib/pgsql/12/data/pg_hba.conf 
cp /var/lib/pgsql/10/data/postgresql.conf /var/lib/pgsql/12/data/postgresql.conf 
chown -R postgres:postgres /var/lib/pgsql/12/data/pg_hba.conf 
chown -R postgres:postgres /var/lib/pgsql/12/data/postgresql.conf 

# START NEW DB
systemctl start postgresql-12
systemctl status postgresql-12
su postgres
psql
upgrade 9.6 to latest
Подготовительные работы.
Всё это можно сделать до остановки старого инстанса, чтобы максимально снизить время даунтайма.
Подключаем репозиторий и производим установку сервера новой версии, а также всех используемых дополнений (extensions).
Производим инициализацию бд (только для master-инстансов).
Само обновление выполняется при помощи штатного инструмента pg_upgrade. Причём бинарник всегда берется из папки bin более новой версии (в данном конкретном случае /usr/pgsql-11/bin/pg_upgrade).
Проводим тестовый запуск обновления (с ключом -c):
/usr/pgsql-11/bin/pg_upgrade -c -d /var/lib/pgsql/9.6/data/ -D /var/lib/pgsql/11/data/ -b /usr/pgsql-9.6/bin/ -B /usr/pgsql-11/bin/
где
 -d - путь к старой базе
•	-D - путь к новой базе
•	-b - путь к старым бинари
•	-B - путь к новым бинари
И переходим к следующему пункту)
Собственно обновление (даунтайм)
В первую очередь нужно сохранить в надёжное место файлы pg_hba.conf и postgresql.conf. Далее нужно отключить возможность подключения к субд извне, почистив файл pg_hba.conf и выполнив рестарт сервиса. С этого момента начинается даунтайм.
Теперь вернумся к выводу последней команды предыдущего раздела. Если ошибок нет и всё ок, то останавливаем старый инстанс и запускаем эту же команду без ключа -с:
/usr/pgsql-11/bin/pg_upgrade -d /var/lib/pgsql/9.6/data/ -D /var/lib/pgsql/11/data/ -b /usr/pgsql-9.6/bin/ -B /usr/pgsql-11/bin/
Но у меня такого ни разу не было)
Как правило в результате проверки вылезает какое-нибудь несоответствие между старым и новым кластерами, которое требует устранения.
Чтобы посмотреть версии расширений (установленные в ОС и используемые в базе) воспользуемся командой:
SELECT * FROM pg_available_extensions WHERE installed_version IS NOT null;

Опишу то, с чем пришлось столкнуться мне.
•	отсутствие расширения pglogical в новом кластере. Решение: 11-й постгрес поддерживает логическую репликацию из коробки, поэтому просто подключаемся к базе и выполняем DROP EXTENSION pglogical; (делаем это во всех базах, где оно добавлено)
•	несоответствие версий расширения pg_pathman. Решение: обновляем пошагово (1.3 → 1.4 → 1.5) расширение на старом кластере. Т.е. ставим пакет соответсвующей версии, рестартим сервис, выполняем команду ALTER EXTENSION pg_pathman UPDATE TO "1.4"; и повторяем эти действия до соответствия версий на старом и новом кластерах. (возможно потребуется перед каждым апдейтом отключать расширение командой SET pg_pathman.enable = f;)
•	ошибка при обновлении расширения postgis. Решение: кто-то ранее пытался собрать это расширение из исходников и при этом в системе сохранилась бета-версия одной библиотеки (ogdi). После принудительного её обновления (yum update odgi) расширение без проблем обновилось.
•	ругань на отсутствие библиотеки libssl.so.10 или что-то связанное с libcrypto и libssl. Решение: выполняем команду yum install openssl openssl-lib, после этого проблема исчезает. Кстати, подобные сообщения можно увидеть не только при обновлении кластера, но и при настройке потоковой master-slave репликации на слэйве (в логах постгреса). Рецепт излечения тот же.
После успешного завершения команды pg_upgrade запускаем новый кластер, скопировав старый файл конфигурации postgresql.conf на его место (попутно удалив из него расширение pglogical). Если сервер БД запустился без ошибок, то можно приступить к настройке логической или потоковой репликации. Для этого возвращаем на место файл pg_hba.conf, который мы положили в надёжное место в самом начале и рестартим сервис. С этого момента база начинает принимать коннекты.

ВАЖНО! Если старый сервис не удалён сразу после обновления, то обязательно выполняем disable старого сервиса и enable нового! Иначе после перезагрузки вас ждёт сюрприз!


```
