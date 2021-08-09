```
Смена директории c /var/www/html to /data/var/www
Правим либо в основном конфиге либо в каждом конфиге для каждого сайта
sudo nano /etc/httpd/conf/httpd.conf
DocumentRoot "/data/var/www"

<Directory "/data/var/www">
            Options Indexes FollowSymLinks
            AllowOverride None
            Require all granted
    </Directory>
```