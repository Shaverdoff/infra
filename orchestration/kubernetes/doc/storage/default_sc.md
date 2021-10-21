### SET SC as default
```
[root@k8s-tst1 ~]# kubectl get storageclass
NAME               PROVISIONER            RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
cstor-csi-disk     cstor.csi.openebs.io   Delete          Immediate              true                   45h

# set as default
kubectl patch storageclass cstor-csi-disk -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

kubectl get storageclass
NAME                       PROVISIONER            RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
cstor-csi-disk (default)   cstor.csi.openebs.io   Delete          Immediate              true                   45h
```
