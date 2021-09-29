```
kubectl apply -f pv.yml
helm upgrade -i prometheus-stack -n monitoring -f prometheus-stack.yml prometheus-community/kube-prometheus-stack

```
