# Redis is loading the dataset in memor
https://forum.sentry.io/t/redis-error-111-connecting-to-redis-6379/13324/2
login to the container that runs redis, in my case redis:5.0-alpine
```
docker exec -it sentry_onpremise_redis_1 sh
redis-cli
info
### OUTPUT
# Keyspace
db0:keys=27312300,expires=738681,avg_ttl=1235828231
db1:keys=4,expires=0,avg_ttl=0
#######
# solution, run commands:
FLUSHDB
flushall
```
