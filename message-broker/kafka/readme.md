# USAGE in k8s
```
# RUN POD for service tasks
kubectl run kafka-client --restart='Never' --image docker.io/bitnami/kafka:2.8.0-debian-10-r0 --namespace kafka --command -- sleep infinity


# create topic EMAIL_OUT
/opt/bitnami/kafka/bin/kafka-topics.sh --create --zookeeper kafka-zookeeper:2181 --topic EMAIL_OUT --partitions 1 --replication-factor 1
# topics delete
/opt/bitnami/kafka/bin/kafka-topics.sh --delete --zookeeper kafka-zookeeper:2181 --topic SMS-IN
# list
/opt/bitnami/kafka/bin/kafka-topics.sh --zookeeper kafka-zookeeper:2181 --list
```
