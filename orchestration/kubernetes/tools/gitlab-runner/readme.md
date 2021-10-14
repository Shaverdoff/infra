# Add gitlab-runner with helm
```
# https://gitlab.com/gitlab-org/charts/gitlab-runner/blob/main/values.yaml
helm repo add gitlab https://charts.gitlab.io

# namespace
kubectl create ns gitlab-runner

# set labels to the nodes
kubectl label node k8s-tst2 gitlab-worker=true --overwrite
kubectl label node k8s-tst3 gitlab-worker=true --overwrite

helm upgrade --install --namespace gitlab-runner  gitlab-runner -f values.yml gitlab/gitlab-runner
```
### ISSUE
```
# https://number1.co.za/use-gitlab-to-build-and-deploy-images-to-harbor/
ERROR: Job failed (system failure): secrets is forbidden: User "system:serviceaccount:gitlab-runner:default" cannot create resource "secrets" in API group "" in the namespace "gitlab-runner"
Get all service accounts:
kubectl get sa -A
View the specific service account:

kubectl get sa default -o yaml -n gitlab-runner
It is important to look at kubernetes managing and configuring service accounts. I found this stackoverflow question that gives us the quick fix

So let us edit the serivce account and give it permission (I don't want to give it cluster admin):

kubectl edit sa default -n gitlab-runner
Well it rejected the rule key and documentation is too much or too sparse

I just took the easy / insecure option:

$ kubectl create clusterrolebinding default --clusterrole=cluster-admin --group=system:serviceaccounts --namespace=gitlab
clusterrolebinding.rbac.authorization.k8s.io/default created
```
