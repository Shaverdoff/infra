```
nano /etc/gitlab-runner/config.toml
  [runners.cache]
    Type = "s3"
    #Path = "git-runner1"
    Shared = true 
    [runners.cache.s3]
      ServerAddress = "ms3.amazonaws.com"
      AccessKey = "miniorv"
      SecretKey = "SKFzHq5iDoQgW1gyNHYFmnNMYSvY9ZFMpH"
      BucketName = "git-runners-cache"
      BucketLocation = "eu-west-1"
      Insecure = false
 
# create bucket on s3 with name:
git-runners-cache
# restart runner
systemctl restart gitlab-runner
```
