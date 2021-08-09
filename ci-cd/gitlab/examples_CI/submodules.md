# GIT SUBMODULES 
```
Связанные проекты в гитлаб/Подключение других проектов
Создаем файлик
.gitmodules
[submodule "sql"]
	path = sql
	url = ../test-sql.git

# чтобы избежать проблем с второй авторизацией – всегда указывайте путь относительно текущего проекта.

[submodule "HardwareLib"]
    path = HardwareLib
    url = ../../vbykov/HardwareLib.git


.gitlab-ci.yml
stages:
- pull_stage


pull_stage:
  stage: pull_stage
  before_script:
  - git submodule sync --recursive
  - git submodule update --init --recursive
  script:
  - sudo setfacl -R -m u:gitlab-runner:rwx /data/
  - docker-compose down
  - rm -rf /data/airflow && mkdir -p /data/airflow
  - git clone --recursive https://gitlab-ci-token:${token_monitor}@gitlab.company.org/tko/monitor-python.git /data/airflow
  - cd /data/airflow && docker-compose up -d
  - sudo chmod -R 777 /data/airflow/static/
  tags:
    - monitor_sh
  only:
  - master
```