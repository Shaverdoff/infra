## affinity
```
NODE_AFFINITY = used to permorm the same task as nodeSelector!!!, but it has more options
node-affinity:
- запускает на нодах где есть метка - МЕТКА-ИМЯ
- если не получается, на прошлое правило, можно запустить на других


| Type (HARD or SOFT ) | DuringScheduling |DuringExecution |
| :------------- | :----------: | -----------: |
| Type 1 | required  | Ignored |
| Type 2 | Preferred | Ignored |


pod-affinity:
 поды всегда стояли на разных узлах с одной меткой (типо слэйвы бд на разных нодах)



affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        # DONT RUN PODS ON MASTER NODE
        - key: node-role.kubernetes.io/master
          operator: DoesNotExist
        # RUN POD ON NODE WITH LABEL DSA
        - key: dsa
          operator: Exists






можно использовать ДНС имя для обращения к кластеру БД
clusterIP: none












```
