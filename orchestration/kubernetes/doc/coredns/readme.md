# COREDNS
```
COREDNS это замена устаревшему KUBE-DNS
COREDNS берет настройки DNS из /etc/resolv.conf на системе
COREDNS has metadata label kube-dns for compatible
# check config for COREDNS
kubectl -n kube-system get configmap coredns -oyaml

# logs
kubectl logs --namespace=kube-system -l k8s-app=kube-dns
# verify

# DNS SERVICE UP
kubectl get svc --namespace=kube-system
# Are DNS endpoints exposed?
kubectl get endpoints kube-dns --namespace=kube-system

# STATUS
kubectl -n kube-system get pods -o wide | grep coredns
kubectl get pods --namespace=kube-system -l k8s-app=kube-dns

coredns-74ff55c5b-927mc               1/1     Running   0          16h    10.244.12.3    k8s-ops04                           <none>           <none>
dig @10.244.12.3 kubernetes.default.svc.cluster.local +noall +answer
; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.el7_9.5 <<>> @10.244.12.3 kubernetes.default.svc.cluster.local +noall +answer
; (1 server found)
;; global options: +cmd
kubernetes.default.svc.cluster.local. 30 IN A	10.96.0.1
```
