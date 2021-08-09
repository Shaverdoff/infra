```
# REDIRECT TO HTTPS
nano /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
        ServerName 192.168.4.191
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
        Redirect "/" "https://192.168.1.191/"
</VirtualHost>

```