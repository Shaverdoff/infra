# BACKUP
```

#!/bin/bash
set -e
set -u

## Parameters
DBNAME=dbname
USER=user
PASSWORD=password
DATE=$(date +\%Y-\%m-\%d)
BACKUP_STORE_DIR=/data/mysqldump

full_backup() {
        echo FULL;
        mysqldump -u$USER -p$PASSWORD --skip-lock-tables --single-transaction $DBNAME > $BACKUP_STORE_DIR/$DATE.bak
        find "$BACKUP_STORE_DIR" -maxdepth 1 -type d -ctime +5 | xargs rm -rf;
}

if [ $# -eq 0 ]
then
usage
exit 1
fi

    case $1 in
        "full")
            full_backup
	    ;;
        "help")
            ;;
	*) echo "invalid option";;
    esac

# add to crontab
0 0 * * * root    /opt/backup/mysql_backup.sh full
```
# RESTORE to docker db
```
docker exec -i database mysql -u$USER -p$PASSWORD $DBNAME < $DATE.bak
```
