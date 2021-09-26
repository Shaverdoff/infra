# bash скрипт для проверки состояния слота реплики
```
*/2 * * * * root /opt/postgres_script/pgslot_status.sh 
#!/bin/bash
STATE=$(sudo -u postgres psql -c "select state from pg_stat_replication where application_name='edc_subscription';" | awk 'BEGIN {FNR==3; state = 0}; {if ($1 ~ "streaming") state = 1}; END''{print state}')
if [ "$STATE" == "1" ]
  then systemctl status postgresql-11
else
  echo systemctl stop postgresql-11
fi
```
