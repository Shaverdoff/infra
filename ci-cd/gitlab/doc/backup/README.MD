# Gitlab Backup
# Backups gitlab in docker
# Backups for test
```
docker exec -t gitlab gitlab-backup create SKIP=db,uploads,repositories,builds,artifacts,lfs,registry;
Создает бэкап на свой диск и перекидывает на шару
#on server
nano /srv/gitlab/conifg/gitlab.rb
gitlab_rails['manage_backup_path'] = true
gitlab_rails['backup_path'] = "/var/opt/gitlab/backups/backup"

mkdir -p /srv/gitlab/data/backups/backup
chmod -R 777 /srv/gitlab/data/backups/backup
chown -R root:root /srv/gitlab/data/backups

# /etc/fstab
 //192.168.1.37/backups /opt/backups cifs credentials=/root/.creds 0 0

# cron 
nano /etc/cron.d/gitlab_backup
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
25 22 * * 1-5 root /opt/backup.sh >> /var/log/gitlab_backup.log

сам скрипт бэкапа
#!/bin/bash
find "/data/backups/" -maxdepth 1 -type f -mmin +$((60*23)) -name '*.tar' -delete;
docker exec -t gitlab11-compose_iweb_1 gitlab-backup create; # SKIP=db,uploads,repositories,builds,artifacts,lfs,registry;
docker exec -t gitlab11-compose_iweb_1 gitlab-ctl backup-etc /mnt/backups;
rsync -azP --no-o --no-g /data/backups/ /opt/backups/;
find "/opt/backups/" -maxdepth 1 -type f -mmin +$((60*96)) -name '*.tar' -delete;
```
# crontab
```
0 1 * * 0  docker exec -it git.rendez-vous.ru /opt/gitlab/embedded/bin/registry garbage-collect /var/opt/gitlab/registry/config.yml
0 1 * * * /opt/backup-script/backup.sh >> /tmp/backup_log.txt
```
