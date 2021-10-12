## affinity
```
NODE_AFFINITY = used to permorm the same task as nodeSelector!!!, but it has more options
node-affinity:
- запускает на нодах где есть метка - МЕТКА-ИМЯ
- если не получается, на прошлое правило, можно запустить на других
```

| Type (HARD or SOFT ) | DuringScheduling |DuringExecution |
| :------------- | :----------: | -----------: |
| Type 1 | required  | Ignored |
| Type 2 | Preferred | Ignored |

Examples
```
# set pod to node with label size and key=large or key=small
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: size
            operator: In
            values:
            - large
            - small
            
It has :
key: which defines the parameter like size
operator: here we place the operator: In, it can also have the values like NotIn, Exists. There are more operators which one need to refer to in the Kubernetes doc
value: which defines values for the keys like, large, medium, medium and small, medium or large, only medium, not small, etc..  

In operator, ensures that the Pod is placed in the node based on matching key-value pairs. It can match based on multiple values.
```

Node Affinity Type:
```
### Available:
It has two types of node affinity :
  - requiredDuringSchedulingIgnoredDuringExecution (HARD TYPE)
  - preferredDuringSchedulingIgnoredDuringExecution (SOFT TYPE)
  
| Type (HARD or SOFT ) | DuringScheduling |DuringExecution |
| :------------- | :----------: | -----------: |
| Type 1 | required  | Ignored |
| Type 2 | Preferred | Ignored |

### DuringScheduing:
It is the state when the POD is being created for the first time
# required:
If the parameter is of the type required: In that case, the scheduler will mandate the POD to be scheduled based on the given Affinity rule, so if there are no matching label at the Node side, this pod will not be scheduled in the Node by our scheduler. That is why we can call this a “Hard” type of enforcement rule.
# preferred
If the parameter is of the type preferred: In that case, the scheduler will try to enforce the but will not guarantee, so there are chances that POD may be allowed to schedule in the Node. That is why it also is known as a soft kind of rule, here we have given a choice to the scheduler that placement of pod is not as important as executing the workload.

### DuringExecution:
This is a state where POD is already running in the given NODE.
# “ignored” DuringExecution, as shown in fig1.0
which tells the scheduler to ignore this situation and keep running the POD in the node.
### Planned Type:
" requiredDuringSchedulingrequiredDuringExecution"
Here at the time of POD execution, one can also define it to be of Type requiredDuringExecution instead of ignoredDuringExecution.
which tells the scheduler to evict the running POD, if the NODE in which is was scheduled has been modified and there is no matching label available.



### Planned:
  - requiredDuringSchedulingrequiredDuringExecution
```

