# HELM
# helm install
helm install dsatest --dry-run --debug dsatest/
helm install --create-namespace --namespace dsa --namespace dsa --debug dsatest dsatest/
helm install dsatest dsatest/

# helm upgrade
helm upgrade dsatest dsatest --debug

# helm uninstall
helm uninstall dsatest -n dsa
#### Create first app
```
helm create test
cd test

charts/:  управляемые вручную зависимости пакета, хотя обычно лучше использовать файл requirements.yaml для динамической привязки зависимостей.
templates/: файлы шаблона, которые комбинируются со значениями конфигурации (из файла values.yaml и командной строки) и записываются в манифесты Kubernetes.
Chart.yaml: файл с метаданными о пакете (название/версия пакета, информацию об обслуживании, актуальный сайт и ключевые слова для поиска.
LICENSE: лицензия пакета в текстовом формате.
README.md: файл readme.
requirements.yaml: зависимости пакета.
values.yaml: конфигурация пакета по умолчанию.

helm create dsatest
rm -rf dsatest/templates/*
rm -rf dsatest/values.yaml

# check
helm install test  --dry-run --name test123 --debug dsatest/ 
helm install --debug --dry-run --name test123 dsatest/  --namespace dsatest --create-namespace
# install
helm install dsatest dsatest/
# status
helm get manifest dsatest
kubectl describe cm nginx-configmap
# delete
helm uninstall dsatest
# upgrade
helm upgrade dsatest dsatest/ --set user=AnotherOneUser
# package
helm  package dsatest/
```


# PASTE multiple ENVs
```
# deployment
          env:
            {{- range $key, $value :=  .Values.deployment.backend.container.php.env }}
            - name: {{ $key }}
              value: {{ $value | quote }}
            {{- end }}
```
# DEPENDENCIES (переопределение переменных)
```
например у вас есть зависимость
в этом чарте свой values.yaml
в основном values.yaml
переопределяете значения:
## Configuration for prometheus-node-exporter subchart
##
prometheus-node-exporter:
  namespaceOverride: ""
  tolerations:
  - effect: NoSchedule
    operator: Exists
  - key: "node-role/clickhouse"
    operator: "Exists"
    effect: "NoSchedule"
  - key: "node-role/rvsite"
    operator: "Exists"
    effect: "NoSchedule"

И эти значения уйдут в зависимый чарт
```

