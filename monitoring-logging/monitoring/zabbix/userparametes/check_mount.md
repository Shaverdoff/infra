

### on zabbix side
```
# Create item
name: Check Directory Docker
type: zabbix-agent
key: check.directory.docker["{$CONTAINER_NAME}","{$DIRECTORY}"]
Type of information: Numeric
Update interval: 1m

# Create macros
{$CONTAINER_NAME} - rv-php
{$DIRECTORY} - /data/www
```
### server side
```
nano /etc/zabbix/zabbix_agent2.d/userparameter_mount.conf
UserParameter=check.directory.docker[*], sudo docker exec -t $1 sh -c 'test -d $2 && echo 1 || echo 0'
```
