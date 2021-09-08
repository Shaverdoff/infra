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

# TD-AGENT-BIT.CONF
```

# /etc/td-agent-bit/parsers.conf
[PARSER]
  Name   json
  Format json
  types status:integer bytes_in:integer bytes_out:integer body_bytes_sent:float response_time_microseconds:integer keepalive_requests:integer
  Time_Key time
  Time_Format %Y-%m-%d %H:%M:%S %z

# /etc/td-agent-bit/td-agent-bit.conf
[PARSER]
  Name   json
  Format json
  types status:integer bytes_in:integer bytes_out:integer body_bytes_sent:float response_time_microseconds:integer keepalive_requests:integer
  Time_Key time
  Time_Format %Y-%m-%d %H:%M:%S %z
[root@soap1 td-agent-bit]# ls
parsers.conf  plugins.conf  td-agent-bit.conf
[root@soap1 td-agent-bit]# cat plugins.conf 
[PLUGINS]
    # Path /path/to/out_gstdout.so
[root@soap1 td-agent-bit]# cat td-agent-bit.conf 
[SERVICE]
  flush 5
  daemon Off
  log_level info
  parsers_file parsers.conf
  plugins_file plugins.conf
  HTTP_Server  off
  storage.metrics on

[INPUT]
  name tail
  path /var/log/httpd/*access_log
  tag soap.httpd.access
  parser json
  db /var/log/fluent-bit-httpd-access.db  
  Mem_Buf_Limit       5MB

[INPUT]
  name tail
  path /var/log/httpd/*error_log
  tag soap.httpd.error
  parser json
  db /var/log/fluent-bit-httpd-error.db
  Mem_Buf_Limit       5MB

[OUTPUT]
  Name forward
  Match **
  Host efk.rendez-vous.ru
  Port 24224

[FILTER]
  Name record_modifier
  Match **
  Record hostname ${HOSTNAME}

```















