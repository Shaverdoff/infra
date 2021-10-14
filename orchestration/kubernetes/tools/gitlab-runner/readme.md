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
