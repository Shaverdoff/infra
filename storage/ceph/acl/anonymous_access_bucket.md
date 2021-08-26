# Anonimous access to bucket and files
```
# 1) Create a bucket, e.g. moon bucket
# 2) Set acl policy
nano acl.json
{
 "Version": "2012-10-17",
 "Id": "read-only",
 "Statement": [
   {
     "Sid": "project-read",
     "Effect": "Allow",
     "Principal": {
       "AWS": "*"
     },
     "Action": [
       "s3:ListBucket",
       "s3:GetObject"
     ],
     "Resource": [
       "arn:aws:s3:::*"
     ]
   }
 ]
}

s3cmd  setpolicy acl.json s3://moon
s3cmd info s3://moon

# check it with url like this
https://s3.company.ru/moon/chrome-91-0-a37c4a42-0754-4ee6-a289-7e0db50f3bdd/video.mp4

# Maybe dont need
# access to bucket for all on read
s3cmd setacl  s3://moon --acl-public
```


















