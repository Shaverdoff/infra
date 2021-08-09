# Jira backup
```
#!/bin/bash
##Please update your JIRA Home Directory Path
jira="/var/atlassian/application-data/jira/"
jira_BACKUP=`date +%Y%m%d`
## Create Backups while excluding the attachments and temp folders of JIRA
tar --exclude="$jira/data/attachments/*" --exclude="$jira/tmp/*" -czvf $jira_BACKUP.tar.gz $jira
cp $jira_BACKUP.tar.gz  /data/backup
##The following command have dependency over mailutils/mailx package
#$ echo "Message Body Here" | mail -s "Subject Here" jirasupport@example.com -A $jira_BACKUP.tar.gz
## RSync the contents of the attachments to remote folder ( here we can use EFS .
#rsync -avzh $attach <backup_location>
##Database Backup
##create .pgpass file in the user executing pg_dump command. Edit the file in following format
PGPASSFILE=/data/.pgpass pg_dump -U jiradbuser -h 127.0.0.1 -Fc jiradb > db.$jira_BACKUP.pgsql
tar --czvf db.$jira_BACKUP.tar.gz db.$jira_BACKUP.pgsql
cp db.$jira_BACKUP.tar.gz  <backup_location>
##The following command have dependency over mailutils/mailx package
#$ echo "Message Body Here" | mail -s "Subject Here" jirasupport@example.com -A db.$jira_BACKUP.tar.gz


nano .pgpass
localhost:5432:jiradb:jiradbuser:jiradbpassword
chmod 600 .pgpass
PGPASSFILE=/data/.pgpass pg_dump -U jiradbuser jiradb /data/db.$jira_BACKUP.pgsql
```