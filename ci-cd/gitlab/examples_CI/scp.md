```
SCP 
Useradd gitlab
Создаем ключ
Ssh-keygen
Копируем на текущий сервер !!!
Ssh-copy-id gitlab@IP

Потом заходим в gitlab-ci
Добавляем 
    - eval "$(ssh-agent -s)"
    - echo "${key_user}" | ssh-add -
    - scp -o StrictHostKeyChecking=no -r artifact/*.apk ${user}@${host_user}:/tmp 

И добавляем переменные в гитлаб варс (приватный ключ и юзера с хостом)
```