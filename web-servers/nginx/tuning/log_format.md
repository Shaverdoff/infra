```
# STANDART
    log_format  main  'access_log [$time_local] $remote_addr $http_host $status $body_bytes_sent $http_referer "$http_user_agent" "$http_x_forwarded_for" '
                      '"$request" $request_time $request_length "$request_completion" "$request_uri" $connection_requests '
                      '$upstream_status "$upstream_cache_status" $upstream_header_time "$upstream_addr" $upstream_bytes_received $upstream_connect_time $upstream_response_length $upstream_response_time';


# JSON
    log_format mainold escape=json
      '{'
	      '"request_id":"$request_id",'
        '"time_local":"$time_local",'
        '"remote_addr":"$remote_addr",'
        '"remote_user":"$remote_user",'
        '"http_host":"$http_host",'
        '"request":"$request",'
        '"status_code":$status,'
        '"body_bytes_sent":$body_bytes_sent,'
        '"request_time":$request_time,'
        '"request_length":$request_length,'
        '"http_referrer":"$http_referer",'
        '"http_user_agent":"$http_user_agent",'
        '"http_x_forwarded_for":"$http_x_forwarded_for",'
        '"upstream_status":$upstream_status,'
        '"request_completion":"$request_completion",'
        '"request_uri":"$request_uri",'
        '"connection_requests":$connection_requests,'
        '"upstream_cache_status":"$upstream_cache_status",'
        '"upstream_header_time":$upstream_header_time,'
        '"upstream_addr":"$upstream_addr",'
        '"upstream_bytes_received":$upstream_bytes_received,'
        '"upstream_connect_time":$upstream_connect_time,'
        '"upstream_response_length":$upstream_response_length,'
        '"upstream_response_time":$upstream_response_time'
      '}';
```
