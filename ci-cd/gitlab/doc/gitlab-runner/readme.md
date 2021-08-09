# Паралельный запуск job
```
В config.toml 
Добавить параметр
•	concurrent: limits how many jobs globally can be run concurrently. The most upper limit of jobs using all defined runners. 0 does not mean unlimited
•	limit: limit how many jobs can be handled concurrently by this token.
concurrent = 3 // Attribute that limits a number of projects
check_interval = 0
[[runners]]
  limit = 1 // Attribute that limits quantity job by runners
  name = "test-ci"
```
# RUNNER with PROXY
```
Сначало добавляем proxy в службу docker
Configuring Docker for downloading images
mkdir -p /etc/systemd/system/docker.service.d
nano /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://37.29.76.196:443/"
Environment="HTTPS_PROXY=http://37.29.76.196:443/"
systemctl daemon-reload
systemctl restart docker

https://docs.gitlab.com/runner/configuration/proxy.html
https://docs.gitlab.com/runner/configuration/proxy.html#adding-proxy-variables-to-the-runner-config

Создаем службу с proxy – Не работает
mkdir /etc/systemd/system/gitlab-runner.service.d
nano  /etc/systemd/system/gitlab-runner.service.d/http-proxy.conf 
[Service]
Environment="HTTP_PROXY=http://37.29.76.196:443/"
Environment="HTTPS_PROXY=http://37.29.76.196:443/"
systemctl daemon-reload
sudo systemctl restart gitlab-runner
Check:
 systemctl show --property=Environment gitlab-runner

Для работы прокси добавил еще это и docker-compose up –d вместе с build секцией прошел
nano /etc/gitlab-runner/config.toml
[[runners]]
  pre_build_script = "mkdir -p $HOME/.docker/ && echo \"{ \\\"proxies\\\": { \\\"default\\\": { \\\"httpProxy\\\": \\\"$HTTP_PROXY\\\", \\\"httpsProxy\\\": \\\"$HTTPS_PROXY\\\", \\\"noProxy\\\": \\\"$NO_PROXY\\\" } } }\" > $HOME/.docker/config.json"
  pre_clone_script = "git config --global http.proxy $HTTP_PROXY; git config --global https.proxy $HTTPS_PROXY"
  environment = ["HTTPS_PROXY=http://37.29.76.196:443/", "HTTP_PROXY=http://37.29.76.196:443/"]

# Отмена PROXY
https://stackoverflow.com/questions/32268986/git-how-to-remove-proxy/32269086

git config --unset http.proxy
git config --unset https.proxy

на сервер с раннером
su gitlab-runner
cd
ls -la
nano .gitconfig
внутри прописано прокси
rm .gitconfig
systemctl restart gitlab-runner
```

# fatal: unable to access Could not resolve host: gitlab
```
добавить в   [runners.docker] секцию
    extra_hosts = ["gitlab.company.ru:192.168.1.23"]
Если это не помогло
clone_url = http://192.168.1.23
ниже можно добавить это – помогло!
```
# chrome  Failed: chrome not reachable
```
увеличить shm_size до 2гб
nano config.toml
concurrent = 2
check_interval = 0

Это актуально для selenium
https://github.com/SeleniumHQ/docker-selenium#running-the-images
shm_size = 3000000000 = 3gb

```

