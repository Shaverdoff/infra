```
kubectl create ns postgres-cms
helm delete postgres-cms -n postgres
helm upgrade --install postgres-cms -n postgres bitnami/postgresql \
 --set postgresqlPassword=password,postgresqlDatabase=dbname \
 --set persistence.storageClass=ebs-sc \
 --set persistence.accessMode=ReadWriteMany \
 --set persistence.size=8Gi \
 --set service.type=LoadBalancer \
 --set service.nodePort=30600  \
 --set service.annotations."external-dns\.alpha\.kubernetes\.io/hostname"=dbcms-$env.company.com
```
