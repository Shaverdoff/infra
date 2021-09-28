# TAINT
```
# taints и tolerations. С его помощью мы явно указываем, что на этих машинах могут запускаться только контейнеры, у которых прописан toleration к данному taint.
we have node with name - node1
Например, есть машина kube-frontend-1, на которую мы будем выкатывать только Ingress. Добавляем taint на данный узел:

$ kubectl taint node kube-frontend-1 node-role/frontend="":NoExecute

… а у Deployment создаем toleration:

tolerations:
- effect: NoExecute
  key: node-role/frontend
  
  
  
# ADD TAINT ON NODE1
kubectl taint nodes node1 key1=value1:NoSchedule
places a taint on node node1. The taint has key key1, value value1, and taint effect NoSchedule. This means that no pod will be able to schedule onto node1 unless it has a matching toleration.

# REMOVE TAINT ON NODE1
kubectl taint nodes node1 key1=value1:NoSchedule-

# LIST EXISTING TAINTs
kubectl describe node | egrep -i taint

# EXAMPLE WITH POD
---
kind: Deployment
apiVersion: apps/v1
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:stable-alpine
      tolerations:
      - key: "node-role/clickhouse"
        operator: "Exists"
        effect: "NoExecute"
        
add pod
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    env: test
spec:
  containers:
  - name: nginx
    image: nginx:stable-alpine
    imagePullPolicy: IfNotPresent
    
  tolerations:
  - key: "node-role/clickhouse"
    operator: "Exists"
    effect: "NoExecute"
  - key: "key1"
    operator: "Exists"
    effect: "NoSchedule"
    
```
## label
```
# show labels
kubectl get nodes --show-labels

# add label from node
kubectl label node <node name> node-role.kubernetes.io/<role name>=<key - (any name)>
kubectl label nodes <node name> clickhouse=true
kubectl label node <node name> node-role.kubernetes.io/worker= --overwrite

# delete label from node
kubectl label node <node name> node-role.kubernetes.io/<role name>-
kubectl label node <nodename> <labelname>-
```

