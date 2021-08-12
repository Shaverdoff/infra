# Обновление
```
Обновление Elasticsearch
Запускаем кибану
Заходим в Management
Upgrade Assistant
Переходим во вкладку Cluster Checkup
Устраняем все проблемы
Переходим на вкладку Reindex Helper – и выпоняем reindex
Возвращаемся обратно на Cluster Checkup и правим остальное
Чек поступления логов в еластик
curl -XGET 'http://localhost:9200/filebeat-*/_search?pretty'
Проверить работу
curl http://127.0.0.1:9200/_cat/health
1550129859 07:37:39 docker-cluster green 1 1 0 0 0 0 0 0 - 100.0%
Доступ
http://172.29.74.49:9200/
```