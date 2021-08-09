# Couchbase EKS

### 1. Install CRD
```
export env=dev
# DOWNLOAD OPERATOR FROM COUCHBASE
https://www.couchbase.com/downloads
# select Couchbase Autonomous Operator (Open Source Kubernetes)
download tar archive, unarchive it, install CRD
#https://docs.couchbase.com/operator/current/install-kubernetes.html
kubectl create -f crd.yaml
# or replace existing
kubectl replace -f crd.yaml -n couchbase
```

### 2. s3 secret for backups
# ADD S3 secret for backups
```
export region=us-east-2 access_key_id="ACCESS_KEY_ID" secret_key_id="SECRET_KEY_ID"
kubectl -n couchbase create secret generic s3-secret \
    --from-literal=region=$region \
    --from-literal=access-key-id=$access_key_id \
    --from-literal=secret-access-key=$secret_key_id
```
### 3. TLS
```
# TLS
git clone http://github.com/OpenVPN/easy-rsa
cd easy-rsa/easyrsa3
./easyrsa init-pki
./easyrsa build-ca
password 1234
./easyrsa build-ca
common name: couchbase-cluster-ca

rm -rf pki/reqs/couchbase-server.req
rm -rf pki/private/couchbase-server.key
rm -rf pki/issued/couchbase-server.crt
rm -rf pkey.key
rm -rf chain.pem

# couchbase cluster with name - apicbdev and namespace couchbase
./easyrsa \
--subject-alt-name=\
DNS:*.apicb$env,\
DNS:*.apicb$env.couchbase,\
DNS:*.apicb$env.couchbase.svc,\
DNS:*.apicb$env.couchbase.svc.cluster.local,\
DNS:apicb$env-srv,\
DNS:apicb$env-srv.couchbase,\
DNS:apicb$env-srv.couchbase.svc,\
DNS:*.apicb$env-srv.couchbase.svc.cluster.local,\
DNS:localhost,\
DNS:*.couchbase.svc,\
DNS:*.company.com\  - set company domain wildcard !!!!!!!
 build-server-full couchbase-server nopass

cp pki/private/couchbase-server.key pkey.key
cp pki/issued/couchbase-server.crt chain.pem
openssl rsa -in pkey.key -out pkey.key.der -outform DER
openssl rsa -in pkey.key.der -inform DER -out pkey.key -outform PEM
# for non-default namespace, say namespace 'couchbase'
kubectl delete secret couchbase-server-tls -n couchbase
kubectl delete secret couchbase-operator-tls -n couchbase
kubectl -n couchbase create secret generic couchbase-server-tls --from-file chain.pem --from-file pkey.key --namespace couchbase
kubectl -n couchbase create secret generic couchbase-operator-tls --from-file pki/ca.crt --namespace couchbase
```

### 4. Install 
```
##### INSTALL WITH HELM ##############
helm repo add couchbase https://couchbase-partners.github.io/helm-charts/
helm repo update
export env=dev
helm upgrade --install apicb$env --values values_$env.yaml -n couchbase couchbase/couchbase-operator
```

### 5. INGRESS DASHBOARD
# change service type to nodeport
# apply ing.yml
# https://apicbdev.company.com/ui/index.html

### 6. Info
== Couchbase-operator deployed.
   # Check the couchbase-operator logs
   kubectl logs -f deployment/apicbdev-couchbase-operator  --namespace couchbase

== Admission-controller deployed.
   # Check the admission-controller logs
   kubectl logs -f deployment/apicbdev-couchbase-admission-controller --namespace couchbase

== Connect to Admin console
   https://console.company.com:18091
   username: user
   password: password

== Manage this chart
   # Upgrade Couchbase
   helm upgrade apicbdev -f <values.yaml> couchbase/couchbase-operator

   # Show this status again
   helm status apicbdev -n couchbase
```

