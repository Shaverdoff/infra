```
Install java 8 jdk 8
Download java
dpkg -i jdk-13.0.2_linux-x64_bin.deb
cp jdk-8u241-linux-x64.tar.gz /usr/lib/
update-alternatives --install /usr/bin/java java   /usr/lib/jdk1.8.0_241/bin/java
java –version

start/stop Jira
/opt/atlassian/jira/bin/start-jira.sh
/opt/atlassian/jira/bin/stop-jira.sh
http://208.117.83.181:8080/secure/Dashboard.jspa
```