# Benchmark
```
# 1 million 1mb file
weed benchmark -master=localhost:9333 -c=10 -n=100000 -replication=001 -size=1048576
# delete
curl "http://localhost:9333/col/delete?collection=benchmark&pretty=y"
```
#### WRITE
```
Concurrency Level:      10
Time taken for tests:   214.393 seconds
Complete requests:      1000000
Failed requests:        0
Total transferred:      1055459467 bytes
Requests per second:    4664.33 [#/sec]
Transfer rate:          4807.63 [Kbytes/sec]

Connection Times (ms)
              min      avg        max      std
Total:        0.3      2.1       55.9      1.7

Percentage of the requests served within a certain time (ms)
   50%      1.7 ms
   66%      2.0 ms
   75%      2.2 ms
   80%      2.4 ms
   90%      3.2 ms
   95%      4.6 ms
   98%      7.1 ms
   99%      9.5 ms
  100%     55.9 ms
```
##### READ
```
Concurrency Level:      10
Time taken for tests:   60.251 seconds
Complete requests:      1000000
Failed requests:        0
Total transferred:      1055416279 bytes
Requests per second:    16597.35 [#/sec]
Transfer rate:          17106.55 [Kbytes/sec]

Connection Times (ms)
              min      avg        max      std
Total:        0.1      0.5       22.6      0.4

Percentage of the requests served within a certain time (ms)
   50%      0.5 ms
   75%      0.6 ms
   90%      0.8 ms
   95%      0.9 ms
   98%      1.2 ms
   99%      1.6 ms
  100%     22.6 ms
```
# SCHEMA
```
 ----------------------------------------------------------------------------------------------------------------
|             HttpClient
|                 |
|             MasterServer1 <====Http/Raft=====> MasterServer2 <====Http/Raft=====> MasterServer3(leader)
|                     ||                                    ||
|               ( grpc||HeartBeat)                   ( grpc||HeartBeat)
|                     ||                                    ||
 | ├─VolumeServer(Multiple) ├─VolumeServer(Multiple)
|                         ├─Stroage
|                             ├─VolumeData(.dat/.idx)
|                                ├─Needles
|                             ├─VolumeData(.dat/.idx)
|                                ├─Needles
|                         ├─Stroage
|                             ├─VolumeData(.dat/.idx)
|                                ├─Needles
|
----------------------------------------------------------------------------------------------------------------
```
#### Архитектура:
```
Когда клиент отправляет запрос на запись, главный сервер возвращает (идентификатор тома, ключ файла, файл cookie, URL-адрес узла тома) для файла. Затем клиент связывается с узлом тома и отправляет содержимое файла POST.
Когда клиенту необходимо прочитать файл на основе (идентификатор тома, ключ файла, файл cookie), он запрашивает у главного сервера идентификатор тома для (URL-адрес узла тома, общедоступный URL-адрес узла тома) или извлекает его из кеша. Затем клиент может ПОЛУЧИТЬ контент или просто отобразить URL-адрес на веб-страницах и позволить браузерам получать контент.
```
#### Data volume
```
это физический носитель для хранения файлов, аналогичный физическим дискам. Значение по умолчанию - 32 ГБ, которое можно изменить до 64 или 128 ГБ.
*Максимальный размер каждого файла не превышает размера одного тома.* Volume - физический диск. Каждый volume может содержать 32 гигибайта (32 ГБ или 8x2 ^ 32 байта), (содержимое выравнивается по 8 байт).
```
#### Data volume server
```
этот сервис управляет несколькими **data volumes**. Среди них сервер тома данных хранит метаданные файлов, и файлами в томе данных можно управлять, обращаясь к метаданным файла (размер метаданных файла составляет всего 16 байт).
Фактические данные хранятся в *stored in volumes on storage nodes*. Один **volume server can have multiple volumes**. One volume server* corresponds to **multiple volumes**.
The actual file metadata is stored in each volume on volume servers. 
```
#### Master server: 
```
Управляет metadata information (data volume metadata). Все VOLUME SERVER управляются главным сервером. Главный сервер содержит идентификатор тома для сопоставления сервера тома. Это довольно статичная информация, и ее легко кэшировать.
Это снижает давление параллелизма со стороны *central master* и распределяет метаданные файлов на *volume server*, обеспечивая более быстрый доступ к файлам (O (1), обычно только одна операция чтения с диска). В метаданных каждого файла накладные расходы на дисковое хранилище составляют всего 40 байтов.
```
## Q.A
#### REPLICATION BUCKET 
```
s3.bucket.create -name clickhouse-backup -replication 000
```
#### Если диски больших размеров, например 10тб, имеет смысл увеличить размер волума
#### Does it support large files, e.g., 500M ~ 10G?
```
Large file will be automatically split into chunks, in weed filer, weed mount, etc.
Например, файл размеров в 100гб, будет поделен на 4 чанка (3х30gb, 1x10gb)
```
#### How to access the server dashboard?
```
SeaweedFS has web dashboards for its different services:
MASTER: http://localhost:9333
Volume: http://localhost:8080/ui/index.html
Filer: http://localhost:8888/
```

#### How plan MAX VOLUMES for volume
```
each volume limit 32gb, so if you have disk with 300gb, you should use max=10volumes
```
#### Storage Size
```
In the current implementation, each volume can hold 32 gibibytes (32GiB or 8x2^32 bytes). This is because we align content to 8 bytes. We can easily increase this to 64GiB, or 128GiB, or more, by changing 2 lines of code, at the cost of some wasted padding space due to alignment.
There can be 4 gibibytes (4GiB or 2^32 bytes) of volumes. So the total system size is 8 x 4GiB x 4GiB which is 128 exbibytes (128EiB or 2^67 bytes).
Each individual file size is limited to the volume size.
```
#### Problems
```
* seaweedfs uses synchronous replication with the following problems:
   a. There is no automatic synchronization mechanism when a volume-server goes offline and goes online.
   b. Synchronous replication needs to wait for each node to rewrite successfully, and the efficiency is relatively low
   c. Although the node's upper and lower lines will quickly notify the master node through the heartbeat, there is still a certain delay. During the period when the Volume-Server is overwritten, the upload failure may occur due to the volume-server that has been offline.
 * Seaweedfs is currently relatively weak in terms of rights management. Currently there is only one whitelist control mechanism to control external read/write permissions/malicious deletion.
```

REPLICATION TABLE
```
Volume number and maximum storage
The default maximum is 7, you can set 100 and so on. . .
volume backup mechanism Replication
000: no replication, only one copy of data, *Default*
001: replicate once on the same rack (стойка)
010: replicate once on a different rack(стойка), but same data center
100: replicate once on a different data center
200: replicate twice on two different data center
110: replicate once on a different rack, and once on a different data center

type is xyz:
x Number of backup copies in other data centers
y The number of different racks backups in different data centers
z The number of backup copies of the same rack on other servers
```
#### PORTS:
```
9333 - master
8080 - volume nodes
```
