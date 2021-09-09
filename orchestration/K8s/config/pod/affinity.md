## affinity
```
affinity - описывает различные способы запускает
node-affinity:
- запускает на нодах где есть метка - МЕТКА-ИМЯ
- если не получается, на прошлое правило, можно запустить на других
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
