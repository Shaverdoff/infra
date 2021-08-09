# nginx.conf
```
# user for nginx
user nginx deploy;
# This number should be, at maximum, the number of CPU cores on your system. , better use - auto
worker_processes  auto;
# # Number of file descriptors used for Nginx.
worker_rlimit_nofile 400000;
error_log  /var/log/nginx/error.log;
pid        /run/nginx.pid;

events {
    accept_mutex off;
    accept_mutex_delay 500ms;
    # Determines how many clients will be served by each worker process.
    worker_connections 2048;
    # The effective method, used on Linux 2.6+, optmized to serve many clients with each thread.
    use epoll;
    # Accept as many connections as possible, after nginx gets notification about a new connection.
    multi_accept on;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    
    # disable nginx version on status page
    server_tokens off;
    
    # LOGs config
    # enable buffer for access logs
    access_log /var/log/nginx/access.log main buffer=16k;
    log_not_found off;
    log_format main escape=json
      '{'
	      '"request_id":"$request_id",'
        '"upstream_response_time":$upstream_response_time'
      '}';


    ### Common conf ###
    ## KEEPALIVE ##
    # Timeout for keep-alive connections. Server will close connections after this time.
    keepalive_timeout 75s;
    # Number of requests a client can make over the keep-alive connection, if set to hight more memory is used!
    keepalive_requests 1000;


    # allow to upload files
    sendfile        on;
    sendfile_max_chunk 512k;
    
    ## GZIP ##
    gzip on;
    gzip_disable "msie6";
    gzip_vary on;
    gzip_comp_level 6;
    gzip_min_length 250;
    gzip_buffers 32 16k;
    gzip_proxied any;
    gzip_types image/svg+xml text/plain application/xml text/css text/js text/xml application/x-javascript text/javascript application/json application/xml+rss application/javascript ~font/ img/svg image/gif application/msword application/pdf application/rtf application/vnd.ms-excel application/vnd.apple.mpegurl image/x-icon text/x-component application/xhtml+xml application/x-font-ttf application/x-font-otf font/opentype;


    ## FIRST BYTE LOAD ##
    # Don't buffer data-sends (disable Nagle algorithm).
    tcp_nodelay     on;
    # Causes nginx to attempt to send its HTTP response head in one packet,  instead of using partial frames.
    tcp_nopush      on;
    
    ## OTHER CONFIG ##
    # Send the client a "request timed out" if the body is not loaded by this time, default 60s
    client_body_timeout 15s;
    # If the client stops reading data, free up the stale client connection after this much time, default 60s
    send_timeout 15s;
    
    
    large_client_header_buffers  4 32k;
    #proxy_buffer_size  16k;
    client_header_timeout 15s;
    reset_timedout_connection on;
    proxy_hide_header X-Powered-By;
    server_names_hash_max_size 3072;

    ## CACHE ##
    # Caches information about open FDs, freqently accessed files.
    open_file_cache max=200000 inactive=20s;
    open_file_cache_valid 30s;
    open_file_cache_min_uses 2;
    open_file_cache_errors on;
    proxy_cache_key "$scheme$host$request_method$uri$is_args$args";
    # static
    proxy_cache_path /var/cache/nginx_ram levels=1:2 keys_zone=STATIC:4096m inactive=60m max_size=50G use_temp_path=off;
    # api_v2 cache
    proxy_cache_path /var/cache/nginx/api_v2_cache keys_zone=apiv2_cache:1024m levels=1:2 inactive=5m max_size=2G use_temp_path=off;
    index   index.html index.htm;
    add_header X-XSS-Protection "1; mode=block";
    #add_header X-Frame-Options SAMEORIGIN;
    add_header X-CONTENT-TYPE-OPTIONS   nosniff;
    add_header P3P "policyref='/w3c/p3p.xml', CP='NON DSP ADM DEV PSD IVDo OUR IND STP PHY PRE NAV UNI'";


    # SERVERS CONFIGS
    # include /etc/nginx/conf.d/*.conf;
    # example
    server {
      listen 10.10.16.10:443 ssl http2 default_server backlog=250000 reuseport;  
      include /etc/nginx/common/ssl.conf;  
      server_name  _;  
      root /usr/share/nginx/bin;
    }
}

```
