```
docker-compose.yml
    blackboxexporter:
    image: prom/blackbox-exporter:v0.13.0
    container_name: blackboxexporter
    restart: unless-stopped
    ports:
      - "9115:9115"
    volumes:
      - ./blackboxexporter/:/etc/blackboxexporter/
    command:
      - '--config.file=/etc/blackboxexporter/config.yml'
    networks:
      - monitor-net
    labels:
      org.label-schema.group: "monitoring"

Добавляем правило в prometheus.yml
# CHECK CONTENT ON PAGE
  - job_name: 'blackbox'
    scrape_interval: 60s
    metrics_path: /probe
    params:
      module: [dcs_results]  # Look for a HTTP 200 response.
    static_configs:
      - targets:
        - https://codesearch.debian.net/search?q=i3Font
    relabel_configs:
      - source_labels: [__address__]
        regex: (.*)(:443)?
        target_label: __param_target
        replacement: ${1}
      - source_labels: [__param_target]
        regex: (.*)
        target_label: instance
        replacement: ${1}
      - source_labels: []
        regex: .*
        target_label: __address__
        replacement: 172.29.74.49:9115  # Blackbox exporter.
# CHECK STATUS CODE 200
  - job_name: 'blackbox'
    scrape_interval: 30s
     scrape_timeout: 10s
    metrics_path: /probe
    params:
      module: [http_2xx] # Look for a HTTP 200 response.
    static_configs:
      - targets: 
        - https://www.robustperception.io/
        - http://prometheus.io/blog
        - http://yourdomain/usage-api/health
        - http://yourdomain/google-apm/health
        - https://google.com            
        - https://www.telegraph.co.uk
        - https://ets-test.mos.ru/services/waybill?limit=1&offset=0&sort_by=number%3Adesc
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: 172.29.74.49:9115 # Blackbox exporter.


Blackbox exporter config.yml – создаем модуль
modules:
# CHECK 200 STATUS CODE ON PAGE
  http_2xx:
    prober: http
    timeout: 5s
    http:
      valid_http_versions: ["HTTP/1.1", "HTTP/2"]
      valid_status_codes: []  # Defaults to 2xx
      method: GET
      no_follow_redirects: false
      fail_if_ssl: false
      fail_if_not_ssl: false
      fail_if_matches_regexp:
        - "Could not connect to database"
      tls_config:
        insecure_skip_verify: false
      preferred_ip_protocol: "ip4" # defaults to "ip6"
# CHECK CONTENT ON JSON PAGE 
  http_post_json:  #module name
    prober: http	# тип модуля
    timeout: 5s
    http:
      valid_status_codes: []  # valid status code page - Defaults to 2xx - 200
      method: POST  # method post/get
      headers:				#send headers
        Content-Type: application/json
        login: test_marm
        password: test_marm
      body: '{"login":"test_marm","password":"test_marm"}'  # отправляем данные
      fail_if_not_matches_regexp:
        - '\"result\"\:\s?\"There are some errors.\"'
        - '\"medical_stats.list\"'        # ошибка если нет совпадения на странице (можно много совпадений проверять)
      preferred_ip_protocol: "ip4"  # протокол ip4/ip6
  dcs_results:		# другой модуль
    prober: http
    timeout: 5s
    http:
      valid_status_codes: []
      fail_if_not_matches_regexp:
      - "load_font"
      headers:
        Content-Type: application/json
      preferred_ip_protocol: "ip4" # defaults to "ip6"
      method: POST

Аналог в CURL

curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"login":"test_marm","password":"test_marm"}' \
  https://ets-test.mos.ru/services/auth

аналог в GET – не работает - пример
  http_test_2xx:
    prober: http
    timeout: 5s
    http:
      valid_http_versions: ["HTTP/1.1", "HTTP/2"]
      valid_status_codes: []  # Defaults to 2xx
      method: GET
      no_follow_redirects: false
      fail_if_ssl: false
      fail_if_not_ssl: false
#      fail_if_matches_regexp:
#        - "There are some errors"
      fail_if_not_matches_regexp:       #  Probe fails if response does not match regex.
        - "There are some errors"
      tls_config:
        insecure_skip_verify: false
      preferred_ip_protocol: "ip4" # defaults to "ip6"
Здесь можно проверить
http://172.29.74.49:9115/
```





