```
php-fpm.d/www.conf
; TIMEOUT
request_terminate_timeout = 2m
php.ini
; TIMEOUTS
default_socket_timeout = 120
max_execution_time = 900
max_input_time = 120
nginx.conf
keepalive_timeout   120;
fastcgi_read_timeout 600;
proxy_connect_timeout 600;
proxy_send_timeout 600;
proxy_read_timeout 600;
send_timeout 600;
```
