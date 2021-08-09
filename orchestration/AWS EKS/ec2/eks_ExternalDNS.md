
## ExternalDNS
### INSTALLATION with helm
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# AWS, ACCESSKEY & SECRETKEY
# go here and create ACCESS KEY
https://console.aws.amazon.com/iam/home?#/security_credentials
##
aws.credentials.accessKey	When using the AWS provider, set aws_access_key_id in the AWS credentials (optional)	""
aws.credentials.secretKey	When using the AWS provider, set aws_secret_access_key in the AWS credentials (optional)	""

# install (in values.yml change txt-owner)
export env=dev
cp values_qa.yaml values_prod.yaml
nano values_$env.yaml
helm upgrade --install apidns -f values_$env.yaml bitnami/external-dns --version 4.12.2

# CHECk
kubectl --namespace=default get pods -l "app.kubernetes.io/name=external-dns,app.kubernetes.io/instance=apidns"
kubectl logs -f $(kubectl get po | egrep -o 'apidns-external-dns[A-Za-z0-9-]+')
```








