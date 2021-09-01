# INSTALL
```
kubectl create ns postgres-cms
helm delete postgres-cms -n postgres-cms
helm upgrade --install postgres-cms -n postgres-cms bitnami/postgresql \
 --set postgresqlPassword=password,postgresqlDatabase=dbname \
 --set persistence.storageClass=ebs-sc \
 --set persistence.accessMode=ReadWriteMany \
 --set persistence.size=8Gi \
 --set service.type=LoadBalancer \
 --set service.nodePort=30600  \
 --set service.annotations."external-dns\.alpha\.kubernetes\.io/hostname"=dbcms-$env.company.com
```
# RESTORE DATABASE
```
export POSTGRES_PASSWORD=$(kubectl get secret -n postgres-cms postgres-cms-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
kubectl port-forward -n postgres-cms svc/postgres-cms-postgresql 5432:5432 &
PGPASSWORD="$POSTGRES_PASSWORD" psql -f back_cms.sql --host 127.0.0.1 -U postgres -d shaktidb -p 5432
```
