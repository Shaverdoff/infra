### Установка Keepalived
```
dnf install keepalived
systemctl enable --now keepalived
firewall-cmd --permanent --add-rich-rule='rule protocol value="vrrp" accept'
firewall-cmd --reload
 
 
Конфигурация основной ноды. Заменить значения
{{ ipv4.interface }}  - адрес ноды
{{ keepalived_floating_ip }}  - виртуальный плавающий ip адрес, назначается активной ноде демоном keepalived
vrrp_script chk_haproxy {
  script '/usr/bin/killall -0 haproxy'
  interval 2
  weight 2
}
 
vrrp_instance VI_1 {
  interface {{ ipv4.interface }}
  state MASTER
  virtual_router_id 1
  priority 101
  virtual_ipaddress {
    {{ keepalived_floating_ip }}
  }
  track_script {
    chk_haproxy
  }
}
 
 
Конфигурация резевной ноды
vrrp_script chk_haproxy {
  script '/usr/bin/killall -0 haproxy'
  interval 2
  weight 2
}
 
vrrp_instance VI_1 {
  interface {{ ipv4.interface }}
  state BACKUP
  virtual_router_id 1
  priority 100
  virtual_ipaddress {
    {{ keepalived_floating_ip }}
  }
  track_script {
    chk_haproxy
  }
}
 
 
 
systemctl restart keepalived
 
Установка HAProxy
Установлен пакет haproxy-1.8.23-3.el8.x86_64
dnf install haproxy
systemctl enable --now haproxy
firewall-cmd --permanent --add-port=443/tcp --add-port=8091/tcp  --add-port=80/tcp
firewall-cmd --reload
setsebool -P haproxy_connect_any 1
 
 
Сформировать файл сертификата certkey.crt вида
-----BEGIN CERTIFICATE-----
server cert
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
CA cert
-----END CERTIFICATE-----
-----BEGIN PRIVATE KEY-----
 key
-----END PRIVATE KEY-----
 
 
Cкопировать его в /etc/ssl/ и установить разрешения 600 . Переменная {{ hap_ssl_cert_path }}  будет соответствовать /etc/ssl/certkey.crt
Скопировать приложенный файл error_page.hml в /etc/haproxy
Прописать в файл конфигурации /etc/rsyslog.d/haproxy.conf следующее
local2.*                                                /var/log/haproxy.log
 
 
 
systemctl reload rsyslog
 
Конфигурация
{{ keepalived_floating_ip }} - виртуальный плавающий ip адрес, назначается активной ноде демоном keepalived
{{ hap_ssl_cert_path }} - полный путь к файлу сертификата с ключом
{{ app1_ipv4_address }} - адрес бэкенда1, {{ app2_ipv4_address }} - адрес бэкенда2 , {{ app3_ipv4_address }} - адрес бэкенда3
{{ hap_http_host }} - доменное имя сервиса
{{ hap_stat_admin_password }} - пароль для доступа к статистике
global
        log /dev/log    local2
        chroot  /var/lib/haproxy
        pidfile /var/run/haproxy.pid
        stats timeout 30s
        maxconn 100000
        user haproxy
        group haproxy
        daemon
 
        ssl-default-bind-ciphers kEECDH+aRSA+AES:kRSA+AES:+AES256:RC4-SHA:!kEDH:!LOW:!EXP:!MD5:!aNULL:!eNULL
 
defaults
        log global
        maxconn 100000
        option forwardfor
        option http-server-close
        option httplog
        option dontlognull
        option redispatch
        retries 3 
 
        timeout connect 1s
        timeout client  30s
        timeout server  50s
        timeout http-request 10s
        timeout http-keep-alive 10s
 
    errorfile 400 /etc/haproxy/error_page.html
    errorfile 500 /etc/haproxy/error_page.html
    errorfile 502 /etc/haproxy/error_page.html
    errorfile 503 /etc/haproxy/error_page.html
    errorfile 504 /etc/haproxy/error_page.html
    errorfile 403 /etc/haproxy/error_page.html
    errorfile 408 /etc/haproxy/error_page.html
 
 
frontend appdisk
       bind {{ keepalived_floating_ip }}:80
       bind {{ keepalived_floating_ip }}:443 ssl crt {{ hap_ssl_cert_path }} ssl-min-ver TLSv1.2 
       redirect scheme https code 301 if !{ ssl_fc }
       #http-request set-header X-Forwarded-Port %[dst_port]
       http-request add-header X-Forwarded-Proto https if { ssl_fc }
       stats enable
       maxconn 90000
       mode http
       default_backend app_nodes
 
backend app_nodes
        mode http
        stats enable
        balance roundrobin
        option httpchk HEAD /login HTTP/1.1\r\nHost:{{ hap_http_host }}        
        cookie SERVERID insert indirect nocache
    server app1 {{ app1_ipv4_address }}:80 cookie A maxconn 3000 check
    server app2 {{ app2_ipv4_address }}:80 cookie B maxconn 3000 check 
    server app3 {{ app3_ipv4_address }}:80 cookie C maxconn 3000 check 
 
listen  stats
    bind *:8091 ssl crt {{ hap_ssl_cert_path }} ssl-min-ver TLSv1.2
        mode http
        stats enable
        stats uri /stat
        stats hide-version
        stats auth admin:{{ hap_stat_admin_password }}
        stats refresh 5s
 
 
 
 
systemctl relaod haproxy
```
