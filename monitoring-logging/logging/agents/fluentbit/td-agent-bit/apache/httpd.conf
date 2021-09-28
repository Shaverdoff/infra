# HTTPD.CONF
# cat /etc/httpd/conf/httpd.conf
```
ErrorLogFormat '{"time":"%{%Y-%m-%d}t %{%T}t %{%z}t", "remote_addr":"%a", "error_log_level":"%l", "actual_error":"%M"}'

LogFormat '{"time":"%{%Y-%m-%d}t %{%T}t %{%z}t","http_content_type":"%{Content-type}i","server":"%v", "Host":"%V","body_bytes_sent":%B, "bytes_in":%I, "bytes_out":%O, "local_ip":"%A", "remote_addr":"%a","dest_port":%p, "File":"%f", "http_method":"%m", "uri_path":"%U", "uri_query":"%q", "client":"%h", "status":%>s, "response_time_microseconds":%D, "http_user_agent":"%{User-agent}i", "http_referrer":"%{Referer}i", "keepalive_requests":%k}' jsonlog

CustomLog "logs/access_log" jsonlog

```
# cat /etc/httpd/conf.d/ssl.conf
```
LogFormat '{"time":"%{%Y-%m-%d}t %{%T}t %{%z}t","http_content_type":"%{Content-type}i","server":"%v", "Host":"%V","body_bytes_sent":%B, "SSL_PROTOCOL":"%{SSL_PROTOCOL}x","SSL_CIPHER":"%{SSL_CIPHER}x", "bytes_in":%I, "bytes_out":%O, "local_ip":"%A", "remote_addr":"%a","dest_port":%p, "File":"%f", "http_method":"%m", "uri_path":"%U", "uri_query":"%q", "client":"h", "status":%>s, "response_time_microseconds":%D, "http_user_agent":"%{User-agent}i", "http_referrer":"%{Referer}i", "keepalive_requests":%k}'
ErrorLogFormat '{"time":"%{%Y-%m-%d}t", "remote_addr":"%a", "error_log_level":"%l", "actual_error":"%M"}'
```












