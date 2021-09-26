### Создание пользователя
```
CREATE USER tester321 WITH PASSWORD '321';
GRANT ALL PRIVILEGES ON DATABASE "opencity_chel" to tester321;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO root;
```
### Удаление пользователя
```
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM tester321;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM tester321;
REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public FROM tester321;
REVOKE ALL PRIVILEGES ON DATABASE opencity_chel FROM tester321;
DROP USER tester321;
```
### Управление пользователями
```
### Создание пользователя
CREATE USER tc WITH password 'Pa$$w0rd';
# Назначение прав
### Все права на БД teamcity
GRANT ALL PRIVILEGES ON DATABASE teamcity TO tc;
### Только на SELECT в схеме bigdata
GRANT SELECT ON ALL TABLES IN SCHEMA bigdata to services_user;
### Все права на схему bigdata
GRANT ALL PRIVILEGES ON SCHEMA bigdata to services_user;
### Создание роли RO и пользователей
CREATE ROLE group_ro;
GRANT USAGE ON SCHEMA public TO group_ro;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO group_ro;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO group_ro;
--ALTER DEFAULT PRIVILEGES - меняет дефолтные привелегии для объектов, соданных ролью, под которой запускается ALTER DEFAULT PRIVILEGES--
--Перед этим выполнить:--
SET  ROLE role_name;
--где role_name - роль, создающая новые объекты, к примеру service_user на ag --
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO group_ro;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON SEQUENCES TO group_ro;
Повторить со всеми схемами, которые нужны этой роли.
### Создание роли RW
GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA public TO group_rw;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO group_rw;
 
ALTER DEFAULT PRIVILEGES FOR ROLE group_rw  IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO user_name;
### Создание пользователя, наследующего разрешения роли:

sudo -u postgres createuser -g group_ro -P user_name
### Поиск объектов, к которым нет доступа у роли
### Пример для бд prod_ag и роли group_ro
SELECT schemaname||'.'||relname FROM pg_stat_all_tables WHERE schemaname NOT IN('pg_catalog','pg_toast','information_schema') and  relname not in(select table_name from information_schema.table_privileges where table_catalog='prod_ag' and grantee='group_ro' and privilege_type='SELECT');
```
### POSTGRES CREATE ADMIN
createuser -s -i -d -r -l -w icapadm
psql -c "ALTER ROLE icapadm WITH PASSWORD 'icap341$!erv';"
