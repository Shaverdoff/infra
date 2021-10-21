# INGRESS CONTROLLER 
### Installation
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
kubectl create ns ingress-nginx
# add label on node
kubectl label node node2 ingress=
# delete label on node
kubectl label node node1 ingress-

# create default ssl certificate
kubectl create secret tls tls-secret --key rendez-vous.key --cert rendez-vous.crt -n ingress-nginx
# delete
helm delete ingress-nginx -n ingress-nginx
# install
export replicaCount=1
helm upgrade --install ingress-nginx -n ingress-nginx ingress-nginx/ingress-nginx  \
  --set controller.service.type=NodePort \
  --set controller.hostNetwork=true \
  --set controller.replicaCount=$replicaCount \
  --set controller.extraArgs.default-ssl-certificate=ingress-nginx/tls-secret \
  --set controller.nodeSelector."ingress"='' \
  --set controller.metrics.enabled=true \
  --set controller.metrics.serviceMonitor.enabled=true \
  --set controller.metrics.serviceMonitor.additionalLabels.release=prometheus \
  --set controller.tolerations[0].operator=Exists,controller.tolerations[0].effect=NoSchedule \
  --set controller.tolerations[1].operator=Exists,controller.tolerations[1].key=CriticalAddonsOnly \
  --set controller.tolerations[2].operator=Exists,controller.tolerations[2].effect=NoExecute
   

where:
- controller.hostNetwork=true - for low latency
- controller.nodeSelector."ingress"='' - install ingress only on node with label "ingress"
- additionalLabels.release - name of installed prometheus stack
- controller.extraArgs.default-ssl-certificate=ingress-nginx/tls-secret - name of secret with wildcard ssl certificate
# FOR IGNORE TAINTS!
  --set controller.metrics.serviceMonitor.additionalLabels.release=prometheus \
  --set controller.tolerations[0].operator=Exists,controller.tolerations[0].effect=NoSchedule \
  --set controller.tolerations[0].operator=Exists,controller.tolerations[0].key=CriticalAddonsOnly \
  --set controller.tolerations[0].operator=Exists,controller.tolerations[0].effect=NoExecute
```

