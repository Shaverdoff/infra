
# Install
```
pecl install xdebug && docker-php-ext-enable xdebug
```
# Configure
```
nano /etc/php.d/xdebug.ini
[xdebug]
xdebug.mode=debug
XDEBUG_SESSION=PHPSTORM
xdebug.start_with_request=1;Automatically Starting the Debugger
xdebug.client_host=127.0.0.1
xdebug.client_port="9001"; порт для удаленной отладки
xdebug.remote_handler = dbgp; протокол для отладки
xdebug.log=/tmp/xdebug.log; лог-файл для удаленной отладки
xdebug.var_display_max_depth = 6; глубина показа дампа массивов и объектов
xdebug.output_dir = /tmp/xdebug/profiler/; директория для хранения результатов профилирования
xdebug.trigger_value = 1;
xdebug.show_local_vars = 1; отобразить все локальные переменные в случае возникновения ошибки
```
# RUN
```
!!!local value is prioritize
# export ENVs
export XDEBUG_MODE=debug
export XDEBUG_CONFIG="client_host=172.16.24.187 client_port=9001 start_with_request=yes log=/tmp/xdebug.log remote_handler=dbgp xdebug.discover_client_host=1"
# where: client_host=172.16.24.187 client_port=9001 - set ip of client with phpstorm with port PHPSTORM
```
# PHPSTORM
```
add connection to the server with CORRECT PORT - 443
```
# Check status of xdebug v3
```
php -r "xdebug_info();"
```

```
# from your pc create tunnel for PHPSTORM if dont want to use EXTERNAL IP
ssh -R 9001:127.0.0.1:9001 deploy@10.10.10.1
```
# Increase Timeout
```
in nginx.conf add that to php section:
add fastcgi_read_timeout 600proxy_read_timeout s;
proxy_read_timeout 
in php.ini 
max_execution_time = 600
memory_limit = 2048M
```
