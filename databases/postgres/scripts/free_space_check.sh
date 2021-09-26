# bash скрипт для проверки free space disk /data
```
#!/bin/bash
FREE=$(df -k --output=avail "/data" | tail -n1)
SIZE="5242880"
if [ "$FREE" -le "$SIZE" ] 
then
  systemctl stop postgresql-11
else
  systemctl status postgresql-11
fi

```
