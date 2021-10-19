# create multi-kubeconfig
1) OPTION:
get 2 kubeconfig
and just follow that template (paste your certs, its all just symlinks):
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: REDACTED
    server: https://10.3.3.58:6443
  name: prod
- cluster:
    certificate-authority-data: REDACTED
    server: https://10.3.3.93:6443
  name: test
contexts:
- context:
    cluster: prod
    user: kubernetes-admin-prod
  name: prod
- context:
    cluster: test
    user: kubernetes-admin-test
  name: test
current-context: prod
kind: Config
preferences: {}
users:
- name: kubernetes-admin-prod
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED
	- name: kubernetes-admin-test
  user:
    client-certificate-data: REDACTED
	client-key-data: REDACTED

2) just create 2 kubeconfig and switch between them with export KUBECONFIG=/opt/.kube/prod or export KUBECONFIG=/opt/.kube/test



# OTHER
```
# добавить сведения о кластере в файл конфигурации:
# test
kubectl config --kubeconfig=config-demo set-cluster test --server=https://10.3.3.93 --certificate-authority=$PASTE_YOUR_CERT 
# prod
kubectl config --kubeconfig=config-demo set-cluster prod --server=https://10.3.3.58 --certificate-authority=$PASTE_YOUR_CERT
# Добавьте данные пользователя в свой файл конфигурации:
kubectl config --kubeconfig=config-demo set-credentials rvadmin --client-certificate=fake-cert-file --client-key=fake-key-seefile
kubectl config --kubeconfig=config-demo set-credentials rvuser --username=exp --password=some-password

# CONTEXT
kubectl config --kubeconfig=config-demo set-context test --cluster=test --namespace=default --user=rvuser
kubectl config --kubeconfig=config-demo set-context prod --cluster=prod --namespace=default --user=rvadmin
