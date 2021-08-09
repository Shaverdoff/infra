# BUILD

```
npm run build:mf
после двоеточия название модуля
или например build:server
## DOCKERFILE
FROM node:alpine AS builder

COPY ./ /tmp/build
WORKDIR /tmp/build
RUN npm set progress=false && npm i -g typescript --unsafe-perm && npm i
RUN npm run build:server

EXPOSE 3000
CMD [ "node", "dist/server/server.js" ]

Сбилдил в папку dist – запускать это /tmp/build/dist/server/server.js
CMD [ "node", "dist/server/server.js" ]

```

# Cache in ci
```
cache:
  key: "$CI_JOB_STAGE-$CI_COMMIT_REF_SLUG"
  paths:
  - node_modules/
  - .yarn-cache/

build for tag:
  stage: build-tag
  image: mcr.microsoft.com/dotnet/core/sdk:latest
  cache:
    key: "$CI_PROJECT_NAMESPACE-$CI_PROJECT_NAME"
    paths:
      - node_modules
      - .yarn-cache/
    policy: pull

npm config set cache
yarn config set cache-folder .yarn-cache && yarn install --no-progress && yarn run build --no-progress;
```
# Ускорение сборки
```
1)	Поставить новую версию NODEJS
2)	Попробовать сбилдить через yarn
3)	Включить кэш node_modules
```
# BUILD IN PROD MODE
```
In F12 in browser - Angular is running in the development mode.
RUN npm set progress=false && npm i -g @angular/cli --unsafe-perm && npm uninstall node-sass && npm install node-sass && npm i

RUN ng build –prod
Вместо
RUN npm run build

Еще такой не тестил

RUN npm run build:prod

```