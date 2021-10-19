# ExternalDNS AWS
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# ACCESS KEY
https://console.aws.amazon.com/iam/home?#/security_credentials
aws.credentials.accessKey	When using the AWS provider, set aws_access_key_id in the AWS credentials (optional)    ""
aws.credentials.secretKey	When using the AWS provider, set aws_secret_access_key in the AWS credentials (optional)        ""

# install
export secretKey="secretKey" accessKey="accessKey" region="us-east-2"
export env=dev
helm upgrade --install external-dns \
  --set aws.credentials.secretKey=$secretKey \
  --set aws.credentials.accessKey=$accessKey \
  --set aws.region=$region \
  --set policy=sync \
  --set txtPrefix=$env-api \
  --set txtOwnerId=$env bitnami/external-dns --version 4.12.2

# Check
kubectl --namespace=default get pods -l "app.kubernetes.io/name=external-dns,app.kubernetes.io/instance=external-dns"
kubectl logs -f --tail 200 $(kubectl get po | egrep -o 'external-dns[a-zA-Z0-9-]+')

```
