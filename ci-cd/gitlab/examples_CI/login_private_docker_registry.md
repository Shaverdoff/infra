# DOCKER AUTH PRIVATE REGISTRY
```
https://docs.gitlab.com/ee/ci/docker/using_docker_images.html#define-an-image-from-a-private-container-registry
Авторизация для использования образа докера из приватного registry.
Image: registry/test
Добавляем в GITLAB VARs
Переменную
DOCKER_AUTH_CONFIG
Содержимое берем из файла авторизации
$HOME/.docker/config.json
Для этого сначало на машине выполняем авторизацию
docker login
Потом копируем и вставляем в переменную DOCKER_AUTH_CONFIG
Она автоматом используется, в CI править ничего не нужно.
```
