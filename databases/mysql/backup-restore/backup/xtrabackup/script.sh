#!/bin/bash
set -e 
set -u  

usage() { 
        echo "usage: $(basename $0) [option]" 
        echo "option=full: Perform Full Backup"
        echo "option=incremental: Perform Incremental Backup"
        echo "option=restore: Start to Restore! Be Careful!! "
        echo "option=help: show this help"
}

## Parameters
USER=db_user
PASSWORD=db_password
DATE=$(date +\%Y-\%m-\%d)
BACKUP_DIR=/data/mysqldump/xtrabackup/$DATE
DATA_DIR=/data/mysql
BACKUP_STORE_DIR=/data/mysqldump/xtrabackup

full_backup() {
        echo FULL;
        if [ ! -d $BACKUP_DIR ]
        then
            mkdir -p $BACKUP_DIR
        fi

        if [ $BACKUP_DIR == $DATA_DIR ]
        then
            	echo "ERROR: INVALID BACKUP_DIR!!!. aborting....."
                exit -1
        else
                rm -rf $BACKUP_DIR/*;
                echo `date '+%Y-%m-%d %H:%M:%S:%s'`": Cleanup the backup folder is done! Starting backup" >> $BACKUP_DIR/xtrabackup.log
        fi
        
        xtrabackup --backup --user=$USER --password=$PASSWORD --history --compress --slave-info --safe-slave-backup --parallel=4 --compress-threads=4 --target-dir=$BACKUP_DIR/FULL
        echo `date '+%Y-%m-%d %H:%M:%S:%s'`": Backup Done!" >> $BACKUP_DIR/xtrabackup.log
        find "$BACKUP_STORE_DIR" -maxdepth 1 -type d -ctime +14 | xargs rm -rf;
}

incremental_backup()
{
        if [ ! -d $BACKUP_DIR/FULL ]
        then
                echo "ERROR: Unable to find the FULL Backup. aborting....."
                exit -1
        fi

        if [ ! -f $BACKUP_DIR/last_incremental_number ]; then
            NUMBER=1
        else
            NUMBER=$(($(cat $BACKUP_DIR/last_incremental_number) + 1))
        fi
        
        echo `date '+%Y-%m-%d %H:%M:%S:%s'`": Starting Incremental backup $NUMBER" >> $BACKUP_DIR/xtrabackup.log
        if [ $NUMBER -eq 1 ]
        then
                xtrabackup --backup --user=$USER --password=$PASSWORD --history --slave-info --safe-slave-backup --incremental --parallel=4 --compress-threads=4 --target-dir=$BACKUP_DIR/inc$NUMBER --incremental-basedir=$BACKUP_DIR/FULL 
        else
                xtrabackup --backup --user=$USER --password=$PASSWORD --history --slave-info --safe-slave-backup --incremental --parallel=4 --compress-threads=4 --target-dir=$BACKUP_DIR/inc$NUMBER --incremental-basedir=$BACKUP_DIR/inc$(($NUMBER - 1)) 
        fi

        echo $NUMBER > $BACKUP_DIR/last_incremental_number
        echo `date '+%Y-%m-%d %H:%M:%S:%s'`": Incremental Backup:$NUMBER done!"  >> $BACKUP_DIR/xtrabackup.log
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
        "incremental")
        incremental_backup
            ;;
        "restore")
        restore
            ;;
        "help")
            usage
            break
            ;;
        *) echo "invalid option";;
    esac
