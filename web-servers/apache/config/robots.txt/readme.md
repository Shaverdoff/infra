```
nano /var/www/robots.txt
User-agent: *
Disallow: /



nano /etc/httpd/conf/httpd.conf
Alias /robots.txt /var/www/robots.txt

```