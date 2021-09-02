# SYNTAXIS
```
# RUN WITHOUT DEAMON
buildctl-daemonless.sh build \
# USE DOCKERFILE BUILD TYPE
--frontend=dockerfile.v0 \
# DOCKERFILE NAME
--opt filename=Dockerfile \
# DIRECTORY for BUILD
--local context=. \
# PATH TO DOCKERFILE
--local dockerfile=ci/docker \
# EXPORT/IMPORT CACHE
--export-cache type=registry,ref=dockerregistry.rendez-vous.ru/rv_dev/jmsca/test:buildcache,push=true \
--import-cache type=registry,ref=dockerregistry.rendez-vous.ru/rv_dev/jmsca/test:buildcache,push=true \
# OUTPUT TO REGISTRY
--output type=image,name=dockerregistry.rendez-vous.ru/rv_dev/jmsca/test:latest,push=true
```
