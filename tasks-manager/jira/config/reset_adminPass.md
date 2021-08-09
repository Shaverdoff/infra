# Reset Jira password
```
/data/atlassian/jira/bin/setenv.sh
# add that
JVM_SUPPORT_RECOMMENDED_ARGS="-Djava.awt.headless=true -Datlassian.recovery.password=temporarypassword"
# Restart and login with that:
recovery_admin/temporarypassword
```