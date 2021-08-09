# TRIGGERS
### Trigger job from 1 pipilene to 2
```
#### Project 1
variables:
  REF_NAME: remaster
  TRIGGER_JOB_NAME: aaa

stages:
  - trigger

trigger_build:
  stage: trigger
  image: curlimages/curl
  script:
    - "curl -X POST -F token=${TRIGGER_TOKEN} -F variables[TRIGGER_JOB]=${TRIGGER_JOB_NAME} -F ref=${REF_NAME} http://git2.altarix.org/api/v4/projects/2337/trigger/pipeline"
  tags: 
    - docker

#### Project 2

Go Settings=>CI/CD=>Pipeline triggers=> add new trigger, copy token to 1 project
aaa:
  stage: build
  image: docker:stable-git
  script:
  - $DOCKER_LOGIN
  - docker build -t ${DOCKER_IMAGE_NAME} -f ./$CI_JOB_NAME/Dockerfile .
  - docker push ${DOCKER_IMAGE_NAME}
  tags:
    - docker
  rules:
  - if: '$TRIGGER_JOB == "aaa"'
```
#RUN CI FROM ANOTHER PROJECT CI - OLD
```
traefik-router-prod-deploy:
  stage: deploy-to-env
  script:
    - curl -X POST -F token=$DEPLOY_TRIGGER
      -F "ref=fkr_route_prod_test"
      -F "variables[DEPLOY_PIPELINE]=$CURRENT_BRANCH"
      -F "variables[ANSIBLE_DEPLOY_HOST]=prod"
      http://git2.altarix.org/api/v4/projects/236/trigger/pipeline
  when: manual

```