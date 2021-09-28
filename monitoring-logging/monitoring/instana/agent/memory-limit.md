```
рекомендуют сделать следующее:
Create a folder: /etc/systemd/system/instana-agent.service.d
Inside instana-agent.service.d directory  create a file memory.conf

[Service]
Environment=AGENT_MAX_MEM=1024m
Environment=INSTANA_USE_MEMORY_CALCULATOR=true

Reload the daemon:
systemctl daemon-reload 
Then restart the agent:
systemctl restart instana-agent.service
 
Это увеличит heap memory агента Instana и также должно помочь снизить нагрузка на CPU.





```







