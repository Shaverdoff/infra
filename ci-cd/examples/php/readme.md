# PHP-FPM управляет конфигом php.ini и значения в php-fpm приоритетнее
```
/etc/php-fpm.d/www.conf
php_admin_value[memory_limit] = 1G


php.ini
memory_limit = 1G
```
