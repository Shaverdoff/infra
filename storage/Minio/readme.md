# Minio
### PREREQ
```
!!! размер стореджа по самому маленькому диску!!!
!!! рекомендовано создавать диски одного размера!!!
1) DNS
a)
create 4 DNS records with type A
10.3.3.191    minio1.company.ru 
10.3.3.195    minio2.company.ru
10.3.3.242    minio3.company.ru
10.3.3.245    minio4.company.ru
b) ingress
10.3.3.191    minioing.company.ru
10.3.3.195    minioing.company.ru
c)
CNAME ms3.company.ru - minioing.company.ru

2) /etc/hosts
# ON ALL NODES
cat > /etc/hosts << EOF
10.3.3.191    minio1.company.ru 
10.3.3.195    minio2.company.ru
10.3.3.242    minio3.company.ru
10.3.3.245    minio4.company.ru
127.0.0.1     localhost
EOF

3) Create user
useradd minio


4) SSL
copy certs to /etc/ssl
add this to MINIO_OPTS
 --certs-dir /etc/ssl
# Inside the certs directory, the private-key must by named as private.key and public-key must be named public.crt.

5) create data dir for MINIO
mkdir /data
chown -R minio /data

6) ENV file for minio
cat > /etc/default/minio << EOF
MINIO_OPTS="--certs-dir /etc/ssl/rv-ssl --console-address :9001"
MINIO_VOLUMES="https://minio{1...4}.company.ru/data/data{1...1}"
MINIO_ROOT_USER="miniorv"
MINIO_ROOT_PASSWORD="SKFzHq5iDoQgW1gyNHYFmnNMYSvY9ZFMpH"
MINIO_SERVER_URL="https://ms3.company.ru"
EOF
where:
# for 1 disk use
### MINIO_VOLUMES="https://minio{1...4}.company.ru/data/data{1...1}"
# for 2 disks use
### MINIO_VOLUMES="https://minio{1...4}.company.ru/data/data{1...2}"
PS: минимум 2 ноды и по 1 диску, всегда должно быть эквивалентно 4!!!, но не больше 16 нод
#minio server http://host{1...n}/export{1...m}
#host{1...n} - hostname - minio1:9000
#export{1...m} - data folder - /data


7) on servers minio1 and minio2 install nginx
yum install nginx -y
nano /etc/nginx/conf.d/minio.conf
upstream minio_servers {
    server minio1.company.ru:9000;
    server minio2.company.ru:9000;
    server minio3.company.ru:9000;
    server minio4.company.ru:9000;
}

server {
    listen 80;
    server_name ms3.company.ru;
    return 301 https://ms3.company.ru$request_uri;
}

server {
 listen 443 ssl;
 server_name ms3.company.ru;
 ssl_certificate     /etc/ssl/rv-ssl/public.crt;
 ssl_certificate_key /etc/ssl/rv-ssl/private.key;
 ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
 ssl_ciphers         HIGH:!aNULL:!MD5;
 # To allow special characters in headers
 ignore_invalid_headers off;
 # Allow any size file to be uploaded.
 # Set to a value such as 1000m; to restrict file size to a specific value
 client_max_body_size 0;
 # To disable buffering
 proxy_buffering off;

 location / {
   proxy_set_header X-Real-IP $remote_addr;
   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
   proxy_set_header X-Forwarded-Proto $scheme;
   proxy_set_header Host $http_host;

   proxy_connect_timeout 300;
   # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
   proxy_http_version 1.1;
   proxy_set_header Connection "";
   chunked_transfer_encoding off;
   proxy_pass       https://minio_servers;
   # Health Check endpoint might go here. See https://www.nginx.com/resources/wiki/modules/healthcheck/
   # /minio/health/live;
 }
}


systemctl start nginx
systemctl enable nginx
```

### Installation
```
# https://min.io/download#/linux
dnf install https://dl.min.io/server/minio/release/linux-amd64/minio-20211010165330.0.0.x86_64.rpm

# systemd
cat > /etc/systemd/system/minio.service << EOF
[Unit]
Description=MinIO
Documentation=https://docs.min.io
Wants=network-online.target
After=network-online.target
AssertFileIsExecutable=/usr/local/bin/minio

[Service]
WorkingDirectory=/usr/local/
User=minio
Group=minio
ProtectProc=invisible
EnvironmentFile=/etc/default/minio
ExecStartPre=/bin/bash -c "if [ -z \"${MINIO_VOLUMES}\" ]; then echo \"Variable MINIO_VOLUMES not set in /etc/default/minio\"; exit 1; fi"
ExecStart=/usr/local/bin/minio server $MINIO_OPTS $MINIO_VOLUMES
Restart=always
# Specifies the maximum file descriptor number that can be opened by this process
LimitNOFILE=65536
# Specifies the maximum number of threads this process can create
TasksMax=infinity
# Disable timeout logic and wait until process is stopped
TimeoutStopSec=infinity
SendSIGKILL=no

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemctl enable minio
systemctl start minio.service
systemctl status minio.service

systemctl restart minio.service
systemctl status minio.service
```
### Minio WebUI
https://ms3.company.ru:9001/dashboard

###################
### CLIENT
###################
```
# INSTALL
dnf install https://dl.min.io/client/mc/release/linux-amd64/mcli-20211007041958.0.0.x86_64.rpm
#########
# ALIAS
#########
# create alias
mcli alias set <ALIAS> <YOUR-S3-ENDPOINT> <YOUR-ACCESS-KEY> <YOUR-SECRET-KEY> --api <API-SIGNATURE> --path <BUCKET-LOOKUP-TYPE>
mcli alias set s3 https://ms3.company.ru miniorv SKFzHq5iDoQgW1gyNHYFmnNMYSvY9ZFMpH --api S3v4
# list aliases
mcli alias ls
mcli alias ls s3
# remove alias minio
mcli rm minio

#Создаем подключение к Minio под названием s3.
mcli config host add s3 https://minio1.company.ru:9000 miniorv SKFzHq5iDoQgW1gyNHYFmnNMYSvY9ZFMpH

#########
# POLICY
#########
# list all policy
mcli admin policy list s3

consoleAdmin        
diagnostics         
readonly            
readwrite           
writeonly

#########
# BUCKET
#########
# list of buckets
mcli ls
# tree
mcli tree s3
# size
mcli du s3
##Создаем bucket.
mcli mb s3/onec
mcli mb s3/clickhouse-backup

######## User
# список пользователей
mcli admin user list TARGET
mcli admin user list s3
mcli admin user list --json s3
# создать юзера
mcli admin user add TARGET USERNAME PASSWORD
# onec user
mcli admin user add s3 yTzw7dbcgpXC9tPGPJmcr 5NYrz7fSZjnV4UCwcVeYv5ds2HsWufAjhAUYzmA
# удалить юзера from target s3
mcli admin user remove s3 CFTC8ZKWDJCVJID2IJZ0
# policy for user
mcli admin policy set s3 writeonly user=yTzw7dbcgpXC9tPGPJmcr
# info 
mcli admin user info s3 CFTC8ZKWDJCVJID2IJZ0

#### GROUP
#добавить группу
mcli admin group add TARGET GROUPNAME MEMBERS
# create group onec and add user
mcli admin group add s3 onec yTzw7dbcgpXC9tPGPJmcr
# info about group
mcli admin group info s3 onec
# list of groups
mcli admin group list s3
# #назначить политику для группы (writeonly, readonly или readwrite)
mcli admin policy set s3 writeonly group=onec
# list all users in group
mcli admin user list s3

# перезагрузка кластера
mcli admin service restart minio 

# SYSTEM INFO
mcli admin config get s3 region
mcli stat s3

# CLICKHOUSE
# bucket
mcli mb s3/clickhouse-backup
# user clickhouse
mcli admin user add s3 clickhouse iHZ1Fh76nUtxcNNTWumqNrF5tucqp82GKBIcGwol
mcli admin policy set s3 writeonly user=clickhouse
# group
mcli admin group add s3 clickhouse clickhouse
mcli admin policy set s3 writeonly group=clickhouse
mcli admin group info s3 clickhouse

# policy
nano {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutBucketPolicy",
        "s3:GetBucketPolicy",
        "s3:DeleteBucketPolicy",
        "s3:ListAllMyBuckets",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::clickhouse-backup"
      ],
      "Sid": ""
    },
    {
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:ListMultipartUploadParts",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::clickhouse-backup/*"
      ],
      "Sid": ""
    }
  ]
}
minio-mc admin policy add s3 clickhouse-backup-policy user.json
minio-mc admin policy set s3 clickhouse-backup-policy user=clickhouse
minio-mc admin user list s3
# test
minio-mc config host add clickhouse-backup https://ms3.company.ru clickhouse iHZ1Fh76nUtxcNNTWumqNrF5tucqp82GKBIcGwol



# test - create file with name test and size 5gb
dd if=/dev/urandom of=test bs=1M count=5000
dd if=/dev/zero of=q bs=1M count=1000 oflag=direct oflag=sync
# 30mb/sec
minio-mc cp test s3/clickhouse-backup/test

echo test11 >> test.1
minio-mc cp test.1 s3/clickhouse-backup/test.1
# check files
minio-mc stat s3/clickhouse-backup
minio-mc cat s3/clickhouse-backup/test.1
minio-mc ls s3/clickhouse-backup/test.1

# SYSTEM
minio-mc admin info s3

# S3
s3cmd --configure






# ceph
radosgw-admin user list
radosgw-admin user create --uid=test1 --display-name="Test1" --email=test1@test.ru




"user": "onec",
"access_key": "yTzw7dbcgpXC9tPGPJmcr",
"secret_key": "5NYrz7fSZjnV4UCwcVeYv5ds2HsWufAjhAUYzmA"
web

```


# docker
```

docker run -d -p 9001:9000 -e "MINIO_ACCESS_KEY=KM9IL4OSS15P0H2TMWPP" -e "MINIO_SECRET_KEY=RQQny9tMVNg0uv1AbVSmykkINhe86UpEgRq+TWLV" -v /data/minio-data:/data -d minio/minio server /data

https://github.com/minio/minio

```

