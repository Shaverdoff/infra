# CROWD SSO
```
For use that – all apps attlastian should be on one domain. Because authorization is stored in cookies browser
https://confluence.atlassian.com/crowd/overview-of-sso-179445277.html
```
# Application in CROWD
```
Go in http://ip_of_crowd:8095/crowd/console/secure/application/addapplicationdetails.action
press add application
```
# Jira application
### Directory, users and groups
```
Don’t create DIRECTORY FOR EVERY PRODUCT ATTLASIAN, use one directory for SSO.
### Add groups in CROWD in directory Crowd Directory:
- jira-users
- jira-developers
- jira-administrators 

### Add user in CROWD jira/jira in directory Crowd Directory, also add to this user groups:
- jira-users
- jira-developers
- jira-administrators 
```
### Add application in Crowd
```
guide here - https://confluence.atlassian.com/crowd/integrating-crowd-with-atlassian-jira-192625.html
Log in to the Crowd Administration Console and navigate to Applications > Add Application
The Name and Password values you specify in the 'Add Application' wizard must match the application.name and application.password that you will set in the JIRA/atlassian-jira/WEB-INF/classes/crowd.properties file.
http://ip_of_crowd:8095/crowd/console/secure/application/browse.action
```
|   |   |   | 
|---|---|---|
|Description      |   value|
|Application Type |   Jira|
|Name	          |   Jira|
|Description	  |   Jira|
|Password/Confirm |   Jira (e.g.,jira/jira)|
|URL	          |     http://ip_of_jira:8080|
|Remote IP address|	|ip_of_jira|
Name/password used for connection crowd => jira
Click next
```
# Connection
URL http://ip_of_jira:8090
Remote IP address ip_of_jira
Click next
# Directories
Crowd server
Click Next
Directory – Crowd server
# Authorization
Allow all users to authenticate
Click Next
Add application
Click Save
```
### Jira to crowd
```
LOGIN TO JIRA
http://ip_of_jira:8080/secure/admin/user/UserBrowser.jspa
go to settings/user management, in left column click on USER DIRECTORIES
 
Click add directory and choice Atlassian Crowd
 
Name – Crowd server
Server url - http://crowd_ip:8095/crowd
Credentials stored in application in CROWD 
http://crowd_ip:8095/crowd/console/secure/application/viewdetails.action?ID=557057&updateSuccessful=true
Application Name - jira
Application Password – jira
Other configs are default
 
Press TEST SETTINGS
Save and test
```
### Configure SSO on server side
```
/opt/atlassian/jira/bin/stop-jira.sh
nano /opt/atlassian/jira/atlassian-jira/WEB-INF/classes/seraph-config.xml
comment line
<!-- <authenticator class="com.atlassian.jira.security.login.JiraSeraphAuthenticator"/> -->
uncomment line
<authenticator class="com.atlassian.jira.security.login.SSOSeraphAuthenticator"/>
  
cp /opt/atlassian-crowd-3.7.1/client/conf/crowd.properties /opt/atlassian/jira/atlassian-jira/WEB-INF/classes 
nano /opt/atlassian/jira/atlassian-jira/WEB-INF/classes/crowd.properties 
application.name                        jira
application.password                jira
application.login.url                   http://ip_of_jira:8095/crowd/console/

crowd.server.url                        http://ip_of_jira:8095/crowd/services/
crowd.base.url                          http://ip_of_jira:8095/crowd/
session.isauthenticated                 session.isauthenticated
session.tokenkey                        session.tokenkey
session.validationinterval              2
session.lastvalidation                  session.lastvalidation
cookie.tokenkey                         crowd.token_key

/opt/atlassian/jira/bin/start-jira.sh
THAT USER WILL BE USED IN – CROWD ADD APPLICATION

Create user in CROWD and give him group Jira-users
Login in to jira with that user
http://ip_of_jira:8080
```

# Confluence
### Directory, users and groups
```
Don’t create DIRECTORY FOR EVERY PRODUCT ATTLASIAN, use one directory for SSO.
# Add group in CROWD
confluence-users
confluence-administrators
in directory - CROWD Directory
# Add user in CROWD
conflu/conflu in directory CROWD Directory
add to this user groups - confluence-users && confluence-administrators
# Add application in Crowd
guide is there - https://confluence.atlassian.com/crowd/integrating-crowd-with-atlassian-confluence-198573.html
Log in to Crowd under administrator => Application => ADD application
http://ip_Of_crowd:8095/crowd/console/secure/application/browse.action
Description	value
Application Type	Confluence server
Name	Confluence
Description	Confluence
Password/Confirm	confluence
URL	http://ip_of_confluence:8090
Remote IP address	ip_of_confluence
Name/password used for connection crowd => confluence
 
confluence/confluence
Click next
Connection
URL http://ip_of_confluence:8090
Remote IP address ip_of_confluence
Click next
Directories
Crowd server
Click Next
Directory – Crowd server
Authorization
Allow all users to authenticate
Click Next
Add application
Click Save
Directory in Confluence to crowd
http://ip_of_confluence:8090/
go to Profile / Administer User
admin/QWE123qwe
select User Directories / Add directory and select Crowd
Enter login/passw – confluence/confluence
 
Press TEST, then save
# Configure SSO on server side
cd /opt/atlassian/confluence/bin
./stop-confluence.sh
nano /opt/atlassian/confluence/confluence/WEB-INF/classes/seraph-config.xml
uncomment string
    <!-- Authenticator with support for Crowd single-sign on (SSO). -->
    <authenticator class="com.atlassian.confluence.user.ConfluenceCrowdSSOAuthenticator"/>
comment string
<!--<authenticator class="com.atlassian.confluence.user.ConfluenceAuthenticator"/>-->
Edit settings crowd.properties
THAT USER WILL BE USED IN CROWD APPLICATION Confluence
cp /opt/atlassian-crowd-3.7.1/client/conf/crowd.properties /opt/atlassian/confluence/confluence/WEB-INF/classes/
nano /opt/atlassian/confluence/confluence/WEB-INF/classes/crowd.properties
application.name                        confluence
application.password                    confluence
application.login.url                   http://ip_of_crowd:8095/crowd/console/
crowd.server.url                        http://ip_of_crowd:8095/crowd/services/
crowd.base.url                          http://ip_of_crowd:8095/crowd/
session.isauthenticated                 session.isauthenticated
session.tokenkey                        session.tokenkey
session.validationinterval              2
session.lastvalidation                  session.lastvalidation
cookie.tokenkey                         crowd.token_key
Start confluence
cd /opt/atlassian/confluence/bin
./start-confluence.sh


Create user in CROWD and give him group Confluence-users
Login in to confluence with that user
http://ip_of_confluence:8090
Add group and login into confluence or jira to check.
```
# Bitbucket
```
# Directory, users and groups
Don’t create DIRECTORY FOR EVERY PRODUCT ATTLASIAN, use one directory for SSO.
# Add group in CROWD
bitbucket-user
bitbucket-admin
# in directory - CROWD Directory. Add user in CROWD to check
bitbucket/bitbucket in directory CROWD Directory
add to this user groups - bamboo-users && bamboo-admin
# Add application in Crowd
http://ip_of_crowd:8095/crowd/console/secure/application/browse.action
# Log in to Crowd under administrator.
Description	| value
Application Type |	Bitbucket server
Name |	bitbucket
Description	| bitbucket
Password/Confirm |	bitbucket
URL	| http://ip_of_bitbucket:7090
Remote IP address |	ip_of_bitbucket
Name/password used for connection crowd => bitbucket
 
Click next
Connection
URL http://ip_of_bitbucket:7090
Remote IP address ip_of_bitbucket
Click next
Directories
Crowd server
Click Next
Directory – Crowd server
Authorization
Allow all users to authenticate
Click Next
Add application
Click Save
Directory in Bitbucket
http://ip_of_bitbucket:7090/
go to Profile / Administer User
admin/QWE123qwe
Administration => User Directories / Add directory and select Crowd
Enter login/passw – bitbucket/bitbucket
Description	Value
Name	Crowd Server
Server URL	http://ip_of_bitbucket:8095/crowd
Application Name	bitbucket
Application Password	bitbucket
Other	blank
Press TEST, then save
Configure SSO
# stop bitbucket
/opt/atlassian/bitbucket/6.10.1/bin/stop-bitbucket.sh
# create dir
mkdir -p /opt/atlassian/bitbucket/6.10.1/shared/
nano /opt/atlassian/bitbucket/6.10.1/shared/bitbucket.properties
# Whether SSO support should be enabled or not. Regardless of this setting SSO authentication 
# will only be activated when a Crowd directory is configured in Bitbucket Server that is configured 
# for SSO.
plugin.auth-crowd.sso.enabled=true

chown -R atlbitbucket:atlbitbucket /var/atlassian/application-data/bitbucket/shared/bitbucket.properties
Start bitbucket
/opt/atlassian/bitbucket/6.10.1/bin/start-bitbucket.sh
```
# Bamboo
```
The same as above.
# Configure SSO
# stop bamboo
/opt/atlassian-bamboo-6.10.4/bin/stop-bamboo.sh 
nano /opt/atlassian-bamboo-6.10.4/atlassian-bamboo/WEB-INF/classes/seraph-config.xml
# comment this line
<!-- <authenticator class="com.atlassian.bamboo.user.authentication.BambooAuthenticator"/> -->
# uncomment this line
<authenticator class="com.atlassian.crowd.integration.seraph.v25.BambooAuthenticator"/>


Edit settings crowd.properties
!!! THAT USER WILL BE USED IN CROWD APPLICATION Bamboo
cp /opt/atlassian-crowd-3.7.1/client/conf/crowd.properties /opt/atlassian-bamboo-6.10.4/atlassian-bamboo/WEB-INF/classes/
nano /opt/atlassian/bamboo/xml-data/configuration/crowd.properties
application.name                        bamboo
application.password                    bamboo
application.login.url                   http://crowd_ip:8095/crowd/console/
crowd.server.url                        http://crowd_ip:8095/crowd/services/
crowd.base.url                          http://crowd_ip:8095/crowd/
session.isauthenticated                 session.isauthenticated
session.tokenkey                        session.tokenkey
session.validationinterval              2
session.lastvalidation                  session.lastvalidation
cookie.tokenkey                         crowd.token_key
Start bamboo
/opt/atlassian-bamboo-6.10.4/bin/start-bamboo.sh

 
```
