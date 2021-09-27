### Обновление 3.6 до 4.6
```
WARNING:  checking setuid bit of if_up_cmd
DETAIL:  ifup[/sbin/ip] doesn't have setuid bit
2019-09-18 11:55:23: pid 1959: WARNING:  checking setuid bit of if_down_cmd
2019-09-18 11:55:23: pid 1959: DETAIL:  ifdown[/sbin/ip] doesn't have setuid bit
2019-09-18 11:55:23: pid 1959: WARNING:  checking setuid bit of arping command
2019-09-18 11:55:23: pid 1959: DETAIL:  arping[/usr/sbin/arping] doesn't have setuid bit

Поидее это решение
cd /sbin/
chmod +s ifup
chmod +s ip
chmod +s arping

Если не получится делал так
mkdir -p  /var/lib/pgsql/sbin
chown postgres:postgres /var/lib/pgsql/sbin
cp /sbin/ip /var/lib/pgsql/sbin
cp /sbin/arping /var/lib/pgsql/sbin

nano /etc/sudoers
postgres ALL = NOPASSWD: /var/lib/pgsql/sbin/ip *, /var/lib/pgsql/sbin/arping *

nano /var/lib/pgsql/sbin/ipadd.sh
#!/bin/bash
sudo /var/lib/pgsql/sbin/ip addr add $1/24 dev ens192 label ens192:0

nano /var/lib/pgsql/sbin/ipdel.sh
#!/bin/bash
sudo /var/lib/pgsql/sbin/ip addr del $1/24 dev ens192

nano /var/lib/pgsql/sbin/arping.sh
#!/bin/bash
sudo /var/lib/pgsql/sbin/arping -U $1 -w 1 -I ens192

chmod 755 /var/lib/pgsql/sbin/*
cd /var/lib/pgsql/sbin/
chmod +s -R /var/lib/pgsql/sbin/

В конфиге pgpool.conf
delegate_IP = '10.10.10.62'
if_up_cmd = 'ipadd.sh $_IP_$'
if_down_cmd = 'ipdel.sh $_IP_$'
arping_cmd = 'arping.sh $_IP_$'
if_cmd_path = '/var/lib/pgsql/sbin'
arping_path = '/var/lib/pgsql/sbin'



КАК ОТЛАЖИВАТЬ - Логи
cd /etc/pgpool-II-11
pgpool -f pgpool-oper.conf -a pool_hba.conf -n

т.е. была проблема в том что не поднимался VIRTUAL_IP, потому что было 2 сервера, и при остановке 1 сервера (службы), он поднимал до мастера второй сервер.
Стопим сервис на 2 сервере, 1 сервер апается до мастера и появляется VIRTUAL_IP.
```
