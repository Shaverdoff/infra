```
добавить количество поток.
Сделать это можно добавив в конфигурации агента configuration.yaml добавьте следующее: 
com.instana.plugin.php: 
  tracing: 
    executorThreads: 12
```
