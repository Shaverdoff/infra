# RUN TEST
```
docker run --entrypoint /bin/bash    \
  -v $(pwd)/config/:/var/loadtest   \
  -v $(pwd)/ssh:/root/.ssh/  \
  --net host                \
  -it direvius/yandex-tank
  
yandex-tank -c load.yaml
```


## Optimizations for server with tank
```
# TANK

ulimit -n 30000
nano /etc/sysctl.conf
net.ipv4.tcp_max_tw_buckets = 65536
# removed from Linux 4.12
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 0
net.ipv4.tcp_max_syn_backlog = 131072
net.ipv4.tcp_syn_retries = 3
net.ipv4.tcp_synack_retries = 3
net.ipv4.tcp_retries1 = 3
net.ipv4.tcp_retries2 = 8
net.ipv4.tcp_rmem = 16384 174760 349520
net.ipv4.tcp_wmem = 16384 131072 262144
net.ipv4.tcp_mem = 262144 524288 1048576
net.ipv4.tcp_max_orphans = 65536
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_syncookies = 0
net.netfilter.nf_conntrack_max = 1048576

```
## Main config of tank
### cat load.yml
```
# PERFOMANCE TOOL
phantom:
  address: 10.3.3.235:443 # [Target's address]:[target's port]
  autocases: 1
  load_profile:
    load_type: rps # schedule load by defining requests per second
    schedule: line(300, 1000, 1m) # starting from 1rps growing linearly to 10rps during 10 minutes
  instances: 1000 # Thread limits
  ssl: true
  header_http: "1.1"
  #headers:
  #  - "[Host: www.rendez-vous.ru]"
  #  - "[Connection: close]"
  # uris: # dont use it with ammofile!
  # - "/"
  timeout: 60s
  ammofile: ammo.txt
  # for basic auth, add header with hash - echo -n admin:123456 | base64
  #ammofile: ammo-corp.txt

autostop:
  autostop:
    #- time(50s,30s) # stop, IF average response time higher than 5000ms for 15s
    - http(5xx,100%,1s) # 5xx codes count higher than 10.0% for 1s
    - net(5xx, 10%, 10s) # stop test, if in the next 10s, 5xx errors more then 10%

console:
  enabled: true # enable console output

# MONITOR SYSTEM STATS (dont forget to copy ssh-key from server with yandex tank to the server with service)
telegraf:
  enabled: false
  config: monitoring.xml
  kill_old: false
  package: yandextank.plugins.Telegraf
  ssh_timeout: 30s

# WEB REPORTS
overload:
  enabled: true
  job_name: TESTRV
  job_dsc: test site
  token_file: token.txt

```

## For Telegraf
### cat monitoring.xml
```
<Monitoring>
  <Host address="10.1.1.111" port="22" interval="1" username="yandextank">
    <CPU />
    <Kernel />
    <Net />
    <System />
    <Memory />
    <Disk />
    <Netstat/>
  </Host>
</Monitoring>
```

## LIST OF URLS
### cat ammo.txt
```
[Connection: close]
[Host: www.rendez-vous.ru]
[Cookie: None]
/

```
## Token for auth to overload
### cat token.txt
```
token_file - ?????? ?????????? ?????????? ???????????????????????????? ???? ?????????? https://overload.yandex.net/ , ???????????????? ???? ???????????????? ?? ?????????????????????? ??????????. ?????????? ?????????? ?????????????? ???????? token.txt ?? ???????????????? ???????? ??????????.
```
