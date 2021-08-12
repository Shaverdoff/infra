# Optimization ELK
## COMPRESS INDEX
```
Menu => Index management => Select index => click in menu Close index => click in menu Edit index settings
"codec": "best_compression",
Save
Open index
при изменении кодека для индекса только новые сегменты (после новой индексации, изменений в существующих документах или слияния сегментов) будут использовать новый кодек.
```
## FORCE MERGE
```
Menu => Index management => Select index => Click Force merge
Работает по аналогии дефрагментации
Освобождает удаленные блоки, и уменьшит размер индекса
```
# for more speed of ELK
```
# DISK
Use ssd
# RAM
50% RAM for elk
# number_of_replicas
Change number of replica – it’s increase speed, but you can lost data, because 0 replica
PUT /_settings
{
"index" : {
"number_of_replicas":0
}
}
# refresh_interval
default 1s
 По умолчанию это 1 с , поэтому новые проиндексированные документы появятся при поиске не более чем через 1 секунду.
Отключение -1, например, во время выполнения массового индексирования, и запустить его вручную в конце.
Увеличиваем до 2с, макс 60с
PUT /_settings
{
  "index" : {
    "refresh_interval" : "2s"
  }
}
```

# Посредник
```
самый главный параметр для ELK – RAM!
Например есть схема
Логи от приложений и отправка их ELASTICSEARCH
1 вариант
Отправщики логов из пролижений напрямую в Elasticsearch.
Минус – в моменты простоя Elasticsearch – теряются данные

2 вариант
Добавить между ними посредника (брокера сообщений), например RABBITMQ
Минус – забивает RAM.

3 вариант
HERCULES (состоит из KAFKA) – хранит данные на дисках. Потери данных не будет.

В ELK  стэке нету Авторизации (она платная есть в X-PACK)
Она есть в HERCULES.
```