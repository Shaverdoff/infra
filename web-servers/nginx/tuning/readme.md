# nginx.conf
```
# user for nginx
user nginx;
# This number should be, at maximum, the number of CPU cores on your system. , better use - auto
worker_processes  auto;
# Number of file descriptors used for Nginx.
# the limit for the maximum FDs on the server is usually set by the OS.
worker_rlimit_nofile 400000;

# only log critical errors, access log will slow down our system.
error_log  /var/log/nginx/error.log;
pid        /run/nginx.pid;

# provides the configuration file context in which the directives
# that affect connection processing are specified.
events {
    accept_mutex off;
    accept_mutex_delay 500ms;
    # Determines how many clients will be served by each worker process.
    # max clients = worker_connections * worker_processes
    # max clients is also limited by the number of socket
    # connections available on the system (~64k)
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
    
    ### LOGs config ###
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
    # Timeout for keep-alive connections. Server will close connections after this time.  -- default 75
    keepalive_timeout 30s;
    # Number of requests a client can make over the keep-alive connection, if set to hight more memory is used!
    keepalive_requests 1000;

    # copies data between one FD and other from within the kernel
    # faster then read() + write()
    sendfile        on;
    sendfile_max_chunk 512k;
    
    ## FIRST BYTE LOAD ##
    # don't buffer data sent, good for small data bursts in real time
    tcp_nodelay     on;
    # send headers in one peace, its better then sending them one by one 
    tcp_nopush      on;
    
    ### TIMEOUTs ###
    client_header_timeout 15s;
    # allow the server to close connection on non responding client, this will free up memory
    reset_timedout_connection on;
    # Send the client a "request timed out" if the body is not loaded by this time, default 60s
    client_body_timeout 15s;
    # If the client stops reading data, free up the stale client connection after this much time, default 60s
    send_timeout 15s;

    ### CACHE ###
    # Caches information about open FDs, freqently accessed files.
    # can boost performance, but you need to test those values
    open_file_cache max=200000 inactive=20s;
    open_file_cache_valid 30s;
    open_file_cache_min_uses 2;
    open_file_cache_errors on;
    proxy_cache_key "$scheme$host$request_method$uri$is_args$args";
    # static
    proxy_cache_path /var/cache/nginx_ram levels=1:2 keys_zone=STATIC:4096m inactive=60m max_size=50G use_temp_path=off;
    # api_v2 cache
    proxy_cache_path /var/cache/nginx/api_v2_cache keys_zone=apiv2_cache:1024m levels=1:2 inactive=5m max_size=2G use_temp_path=off;
    
    ### GZIP ###
    # reduce the data that needs to be sent over network -- for testing environment
    gzip on;
    gzip_min_length 10240;
    gzip_proxied expired no-cache no-store private auth;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/json application/xml;
    gzip_disable msie6;
    
    ## OTHER CONFIG ##
    large_client_header_buffers  4 32k;
    #proxy_buffer_size  16k;
    proxy_hide_header X-Powered-By;
    server_names_hash_max_size 3072;
    add_header X-XSS-Protection "1; mode=block";
    #add_header X-Frame-Options SAMEORIGIN;
    add_header X-CONTENT-TYPE-OPTIONS   nosniff;
    add_header P3P "policyref='/w3c/p3p.xml', CP='NON DSP ADM DEV PSD IVDo OUR IND STP PHY PRE NAV UNI'";



    ### SERVERS CONFIGS ###
    include /etc/nginx/conf.d/*.conf;
}

```
