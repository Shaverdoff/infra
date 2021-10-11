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


```
