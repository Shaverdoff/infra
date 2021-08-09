# GITlAB SSH ACCESS WITH NGINX REVERSY PROXY
```
# Nginx from source
yum install \
gcc \
zlib-devel \
openssl-devel \
make \
pcre-devel \
libxml2-devel \
libxslt-devel \
libgcrypt-devel \
gd-devel \
perl-ExtUtils-Embed \
GeoIP-devel

curl -L https://github.com/nginx/nginx/archive/release-1.18.0.tar.gz > nginx-release-1.18.0.tar.gz
tar xf nginx-release-1.18.0.tar.gz
cd nginx-release-1.18.0
./configure \
--with-pcre \
--prefix=/usr/share/nginx \
--user=nginx \
--group=nginx \
--with-threads \
--with-file-aio \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_xslt_module=dynamic \
--with-http_image_filter_module \
--with-http_geoip_module=dynamic \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_auth_request_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_degradation_module \
--with-http_slice_module \
--with-http_stub_status_module \
--without-http_charset_module \
--with-http_perl_module \
--with-mail=dynamic \
--with-mail_ssl_module \
--with-stream=dynamic \
--with-stream_ssl_module \
--with-stream_realip_module \
--with-stream_geoip_module=dynamic \
--with-stream_ssl_preread_module \
--with-stream 

make
make install
config nginx stream
Компилим nginx из исходников с  модулем stream=dynamic
добавляем модуль в nginx.conf 
# создаем конфиг stream

nano /etc/nginx/nginx.conf
load_module /usr/lib64/nginx/modules/ngx_stream_module.so;
user  nginx;
worker_processes  auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;
worker_rlimit_nofile 40960;

events {
    use epoll;
    worker_connections 16384;
    multi_accept on;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    ignore_invalid_headers off;
    underscores_in_headers on;

    gzip  on;
    gzip_disable "msie6";
    gzip_proxied any;

    server_names_hash_bucket_size 512;
    proxy_headers_hash_max_size 1024;
    proxy_headers_hash_bucket_size 512;


    #gzip  on;
    include /etc/nginx/sites-enabled/*.conf;
}

stream {
  include /etc/nginx/sites-enabled/gitlab.stream;
}

there ssh external port for docker container with gitlab listen on 192.168.1.23:1022
don't forget about port forwarding from external to internal, like 22 external port to 1022 on web-server proxy.
upstream ssh {
  server 192.168.1.23:1022;
}

#upstream web {
#  server gitlab.vko-simvol.ru:443;
#}

map $ssl_preread_protocol $upstream {
  default ssh;
#  "TLSv1.2" web;
}

# SSH и SSL на одном порту
server {
  listen 1022;
  proxy_pass $upstream;
 # ssl_preread on;
}
```