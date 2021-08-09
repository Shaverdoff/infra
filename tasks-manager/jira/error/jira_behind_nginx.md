# Jira behind nginx as reversy proxy

## Обновите базовый url
```
решение
1) сменил его в Настройки/Основные настройки => базовый url
2) на сервере jira стопнул жиру и изменил в server.xml
```
# Проверка состояния Gadget feed URL в вашей системе не удалась.
```
Jira server Base URL health check fails
Проверка состояния URL канала гаджетов в вашей системе не удалась.
ERROR ServiceRunner     [c.a.t.j.healthcheck.support.GadgetFeedUrlHealthCheck]
Checks logs here - /data/atlassian/application-data/jira/log/atlassian-jira.log
Connect to jira.company.ru:80 failed
Сама jira работает на 8080 порту
Решение редиректит все запросы на 80 порт на 8080
iptables -t nat -I OUTPUT -p tcp -o lo --dport 80 -j REDIRECT --to-ports 8080
и добавить запись в /etc/hosts
192.168.1.217 jira.company.ru jira
telnet jira.company.ru 80
nano /data/atlassian/jira/conf/server.xml
        <Connector port="8080" 
        relaxedPathChars="[]|"
        relaxedQueryChars="[]|{}^&#x5c;&#x60;&quot;&lt;&gt;"
        maxThreads="150" 
        minSpareThreads="25" 
        connectionTimeout="20000" 
        enableLookups="false" 
        maxHttpHeaderSize="8192" 
        protocol="HTTP/1.1" 
        useBodyEncodingForURI="true" 
        redirectPort="8443" 
        acceptCount="100" 
        disableUploadTimeout="true" 
        proxyName="jira.company.ru" 
        proxyPort="443" 
        scheme="https"/>
# JIRA BEHIND NGINX HTTPS
iptables -t nat -I OUTPUT -p tcp -o lo --dport 80 -j REDIRECT --to-ports 8080
nano /data/atlassian/jira/conf/server.xml
        <Connector port="8080" 
        relaxedPathChars="[]|"
        relaxedQueryChars="[]|{}^&#x5c;&#x60;&quot;&lt;&gt;"
        maxThreads="150" 
        minSpareThreads="25" 
        connectionTimeout="20000" 
        enableLookups="false" 
        maxHttpHeaderSize="8192" 
        protocol="HTTP/1.1" 
        useBodyEncodingForURI="true" 
        redirectPort="8443" 
        acceptCount="100" 
        disableUploadTimeout="true" 
        proxyName="jira.company.ru" 
        proxyPort="443" 
        scheme="https"/>

tail -f -n 40 /data/atlassian/application-data/jira/log/atlassian-jira.log
systemctl restart jira

В самой jira указываем base url на 	http://jira.company.ru


web conf/server
server {
    listen 80;
    listen 443 ssl;
    server_name jira.vko-simvol.ru;

    access_log /var/log/nginx/jira.vko-simvol.ru.access.log main;
    error_log /var/log/nginx/jira.vko-simvol.ru.error.log;

   ssl_certificate /etc/letsencrypt/live/nextcloud.vko-simvol.ru/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/nextcloud.vko-simvol.ru/privkey.pem;
    include /etc/nginx/ssl.conf;

    location / {
        proxy_pass  http://192.168.1.217:8080;
        include     /etc/nginx/proxy.conf;
    }

   location /.well-known {
        alias /var/www/letsencrypt/.well-known;
   }

    if  ($scheme != https) {
        return 301 https://$server_name$request_uri;
    }
}
```