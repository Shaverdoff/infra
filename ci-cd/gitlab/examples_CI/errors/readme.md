### sudo: sorry, you must have a tty to run sudo
```
nano /etc/sudoers
#Defaults    requiretty
Defaults:gitlab-runner !requiretty
```
### Host key verification failed. lost connection
```
scp ${SSH_CONFIG} -o StrictHostKeyChecking=no ./deploy_mailer/docker-compose.yml deploy@172.29.28.83:/data/deploy_mailer/
решение 
-o StrictHostKeyChecking=no
```
### expected shallow list
```
При запуске CI pipeline on gitlab-runner - вылетает такая ошибка, помогло сменить GIT_STRATEGY
Reinitialized existing Git repository in /home/gitlab-runner/builds/-JSQjkzs/0/floors_cv/floor-cv-web/.git/
fatal: git fetch-pack: expected shallow list
fatal: The remote end hung up unexpectedly
ERROR: Job failed: exit status 1
GIT_STRATEGY: clone

```
### Git kernel ufw block – Ubuntu
```
Gitlab in docker
Git kernel: [  421.561240] [UFW BLOCK] IN=ens160 OUT= MAC=01:00:5e:00:00:fc:38:00:25:08:eb:c0:08:00 SRC=192.168.1.72 DST=224.0.0.252 LEN=56 TOS=0x00 PREC=0x00 TTL=1 ID=40038 PROTO=UDP SPT=56514 DPT=5355 LEN=36
решение
sudo ufw allow out on ens160 to any port 53
```
### gitlab ci artifacts for pages are too large
```
стандарт 100мб
можно увеличить
Admin area/CI CD/ Continuous Integration and Deployment
```
### Problem with the SSL CA cert (path? access rights?)
```
Возникает только на DEBIAN
Выполнить на машине
git config --global http.sslVerify "false"
```
