```
SKYWALKING 
git clone https://github.com/apache/skywalking-docker
cd compose
mv .env.es7 .env
export SW_VERSION=8.7.0
docker-compose up -d
# check url 
10.10.10.10:8080
# start agent with below command, --grpc url to skywalk server
sky-php-agent --grpc 10.10.10.10:11800 /tmp/sky-agent.sock
```
