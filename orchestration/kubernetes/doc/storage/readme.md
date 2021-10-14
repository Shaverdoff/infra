# Выбор storage
### CEPH + ROOK
```
1) ROOK + CEPH (ROOK это обертка над CEPH, он полностью управляет кластером)
+:
1) удобно
2) просто поднять и обслуживать (helm chart)

-: 
1) нельзя расширить текущий диск, только добавлять новый, данный функционал не поддерживается CEPH
```
### GLUSTERFS + HEKETI
```
1) GLUSTERFS + HEKETI (HEKETI это обертка над GLUSTERFS, он полностью управляет кластером)
+:
1) удобно
2) просто поднять и обслуживать (ansible role)
Установка:
GlusterFs server:
  - glusterfs-server
  - heketi only on 1(first) node
  - Добавление сырых дисков без форматирования
Kubernetes nodes:
  - glusterfs-client
  - heketi-manifest (storageclass) only for master kubernetes node
  
-: 
1) танцы с бубном для расширения существующего диска
2) надежность самой heketi (нужно бэкапить базу heketi)
```
### MINIO
```
-: низкая скорость
```
### SEAWEEDFS
```
+:
1) быстрая скорость для маленьких файлов
-:
1) сложности при подключении к кубернетусу и альфа-версия оператора.
```
### OPENEBS
