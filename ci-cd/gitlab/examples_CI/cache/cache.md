# CACHE
### CASHE DISABLE
```
если кэш не нужен и он объявлен глобально в gitlab-ci 
job:
  cache: {}
```
# Использование CACHE
```
https://stackoverflow.com/questions/34162120/gitlab-ci-gradle-dependency-cache/36050711
нужно использовать кэш – для быстрого деплоя – если в проекте используется один и тот же раннер
.gitlab-ci.yml
before_script:
    - export GRADLE_USER_HOME=`pwd`/.gradle

cache:
  paths:
     - .gradle/wrapper
     - .gradle/caches

build:
  stage: build
  script:
     - ./gradlew assemble

test:
  stage: test
  script:
     - ./gradlew check

```