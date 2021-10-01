https://forum.sentry.io/t/sentry-no-more-catch-errors/10500/10
```
Stop sentry
docker-compose stop

Start only Zookeeper and Kafka
docker start sentry_onpremise_kafka_1 sentry_onpremise_zookeeper_1

Hop into the Kafka instance interactively
docker exec -it sentry_onpremise_kafka_1 /bin/bash

Receive consumers list
kafka-consumer-groups --bootstrap-server 127.0.0.1:9092 --list

Get group info
kafka-consumer-groups --bootstrap-server 127.0.0.1:9092 --group snuba-post-processor -describe

Set the offsets to latest
kafka-consumer-groups --bootstrap-server 127.0.0.1:9092 --group snuba-post-processor --topic events --reset-offsets --to-latest --execute

Exit the Kafka instance
exit

Stop Zookeeper and Kafka
docker stop sentry_onpremise_kafka_1 sentry_onpremise_zookeeper_1

Restart the entire stack
docker-compose up

Check the logs. You should see the standard retry errors as it starts up, but the continuous restarts should be resolved.
```
