# ARTIFACTS
### Artifacts between stages
```
stages:
- test
- test2

test:
  stage: test
  script:
  - mkdir -p releases
  - docker cp mongo1:/tmp/1.txt releases/1.txt
  tags:
  - teest
  artifacts:
    paths:
    - releases
    expire_in: 1 week

test2:
  stage: test2
  dependencies: 
    - test
  script:
  - ls -la
  - cd releases && ls -la
  - cat 1.txt
  tags:
  - ansible_docker_test
```
### Artifacts between projects
```
https://gitlab.com/morph027/gitlab-ci-helpers/blob/master/get-last-successful-build-artifact.sh
или
https://gitlab.com/gitlab-org/gitlab-runner/issues/2656
gitlab-ci
LC_TOKEN=$PRIVATE_ACCESS_TOKEN LC_PIPELINE_ID=$CI_PIPELINE_ID ssh -o SendEnv=LC_* -tt [redacted,user]@[redacted,host]
The $PRIVATE_ACCESS_TOKEN is a full-API access token for a project specific user.
script.sh
# Retrieve the asset-build artifact
JOB_ID=`curl -sS --header "PRIVATE-TOKEN: ${LC_TOKEN}" "https://[redacted,host]/api/v4/projects/[redacted,project]/pipelines/${LC_PIPELINE_ID}/jobs" | jq '.[] | select(.name == "build-assets" and .status == "success" and .artifacts_file != null) | .id'`
if [ -z "$JOB_ID" ]; then
  echo "Required asset artifact not found in pipeline #${LC_PIPELINE_ID}"
fi
echo "Downloading artifact for job #${JOB_ID}..."
curl -sS --header "PRIVATE-TOKEN: ${LC_TOKEN}" "https://[redacted,host]/api/v4/projects/[redacted,project]/jobs/${JOB_ID}/artifacts" > build.zip
```
### ARTIFACTS WITH CURL from another project
```
WORKED
curl --location --output artifacts.zip --header "PRIVATE-TOKEN: token" "https://gitlab.company.org/api/v4/projects/1553/jobs/artifacts/master/download?job=testA"
PRIVATE-TOKEN - token USER
WORKED
curl --location --output artifacts.zip "https://gitlab.company.org/api/v4/projects/1553/jobs/artifacts/master/download?job=testA&private_token=KgB6mx-KFKETxKbvo7j4"
PRIVATE-TOKEN - token USER (заходим через админку гитлаба в пользователя и в TOKENS добавляем токен с правами api)
Master - branch
1553 – id project
job=testA – название задачи in CI (верхнее)
 testA:
   stage: deploy
```
### ARTIFACTS gitlab-runner
```
/usr/lib/gitlab-runner/gitlab-runner artifacts-downloader --url https://gitlab.company.org/ --token tokenhash --id 332424
```