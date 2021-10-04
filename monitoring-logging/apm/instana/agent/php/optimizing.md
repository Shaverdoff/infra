# PHP
```
#/opt/instana/agent/etc/instana/configuration.yaml
# Увеличим количество CPU потоков, которые агент может использовать для обработки данных. Это должно помочь PHP сенсору быстрее обрабатывать трейсы и тем самым снизится нагрузка
executorThreads: 32

cat /usr/local/etc/php/conf.d/zzz-instana.ini
[instana]
extension=/usr/local/lib/php/extensions/no-debug-non-zts-20190902/instana.so
instana.socket=127.0.0.1:16816
instana.enable_auto_profile=1
instana.auto_profile_socket=tcp://127.0.0.1:42699
; helm reduce cpu usage
instana.span_chunk_size=750
```
