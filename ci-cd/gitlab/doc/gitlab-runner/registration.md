
# DOCKER RUNNER
```
gitlab-runner register \
  --non-interactive \
  --url "https://git.company.org/" \
  --registration-token "zpLPNcuxxR7v2SLWnoMZ" \
  --description "runner for something on server ..." \
  --tag-list "Forsix_develop" \
  --executor "docker" \
  --docker-image docker:latest \
  --docker-privileged \
  --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" "/cache" \
  --run-untagged \
  --locked="true" 
  
# Docker-volume - строчка нужна чтобы не вылетала ошибка
```
# Shell runner
```
# Устанавливаем раннер на машине под root
gitlab-runner register \
--non-interactive \
--url "https://git.company.org/" \
--registration-token "HaJUQdrvPykoinEctMmz" \
--description "runner for something on server ..." \
--tag-list "repo_sync" \
--executor "shell" \
--run-untagged true

```

# Shared runner (docker)
#### you can get token in admin panel of gitlab.ru/admin/runners
```
gitlab-runner register \
  --non-interactive \
  --url "https://git.company.org/" \
  --registration-token "RnTW57nsxjgCgjzpp3vL" \
  --description "runner for something on server ..." \
  --tag-list "ods-preprod" \
  --executor "docker" \
  --docker-image docker:latest \
  --docker-privileged \
  --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" "/cache" \
  --run-untagged \
  --locked="true"
```
# DOCKER CONTAINER GITLAB-RUNNER
```
docker run -d --name gitlab-runner --restart always \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:latest
```
# DOCKER RUNNER IN DOCKER
```
docker run --rm -t -i -v /srv/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register \
  --non-interactive \
  --url "https://git.company.org/" \
  --registration-token "zKXEeYdLmWnU_4rxLgGx" \
  --description "runner for something on server ..." \
  --tag-list "docker_ag_uat" \
  --executor "docker" \
  --docker-image docker:latest \
  --docker-privileged \
  --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" "/cache" \
  --run-untagged \
  --locked="true"
```
# windows runner
```
install gitlab-runner on windows
install and register then - create 1.bat with this
1.bat
C:\gitlab-runner\gitlab-runner-windows-386.exe register ^
  --non-interactive ^
  --url "https://git.company.org/" ^
  --registration-token "uuKreo318zJggeBx2n5F" ^
  --description "runner for something on server ..." ^
  --tag-list "docker_windows" ^
  --executor "docker" ^
  --docker-image docker:latest ^
  --docker-privileged ^
  --run-untagged ^
  --locked="true" 

# SHELL
C:\gitlab-runner\gitlab-runner-windows-386.exe register ^
  --non-interactive ^
  --url "https://git.company.org/" ^
  --registration-token "uuKreo318zJggeBx2n5F" ^
  --description "runner for something on server ..." ^
  --tag-list "docker_windows" ^
  --executor "shell" ^
  --docker-image docker:latest ^
  --docker-privileged ^
  --run-untagged ^
  --locked="true" 

install docker on windows on VMWARE
in settings give more RAM then 4gb
in settings Hardware Virtualization Expose hardware assisted virtualization to the Guest OS
Cpu/Mmu virtualization Automatic

Install HyperV

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -Verbose
Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -Verbose
bcdedit /set hypervisorlaunchtype Auto

```



