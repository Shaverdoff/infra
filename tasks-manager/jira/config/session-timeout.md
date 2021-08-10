# Session timeout
```
# set to 10 days
!!! The change has to be redone after an upgrade of Jira. !!!

https://confluence.atlassian.com/jirakb/change-the-default-session-timeout-to-avoid-user-logout-in-jira-server-604209887.html
nano /opt/atlassian/jira/atlassian-jira/WEB-INF/web.xml
    <!-- session config -->
    <session-config>
        <session-timeout>864000</session-timeout>
    </session-config>
/opt/atlassian/jira/conf/web.xml
    <session-config>
        <session-timeout>864000</session-timeout>
    </session-config>
```
