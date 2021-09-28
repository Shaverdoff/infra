```
go to aws
select service ECR (elastic container registry)
Visibility settings - Private
Repository name - name of registry
Tag immutability - disabled (images can be overwriten)
Image scan settings - Scan on push - enable (security)
Encryption settings - disabled

# HOW AUTH IN REGISTRY
## get password
aws ecr get-login-password --region us-east-2
docker login --username AWS AWS_ID.dkr.ecr.REGION_ID.amazonaws.com/REGISTRY_NAME
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin AWS_ID.dkr.ecr.REGION_ID.amazonaws.com/REGISTRY_NAME
```
