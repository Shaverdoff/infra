# JIRA LDAP
```
choose  > User Management. 
Choose User Directories.
Add a directory and select one of these types:
LDAP server

Name LDAP Server
Directory Type - OpenLDAP
Hostname: 192.168.1.187
Port 389
Username CN=jira,OU=Users,OU=VKO,DC=vko-simvol,DC=lan
Password QWE123qwe
Base DN OU=VKO,DC=vko-simvol,DC=lan
Additional User DN: OU=Users
Additional Group DN: OU=Groups
LDAP Permissions Read Only
#Another settings – Default
# tests
Test basic connection : Succeeded
Test retrieve user : Succeeded
Test user rename is configured and tracked : Succeeded
Test get user's memberships : Succeeded, 1 groups retrieved
Test retrieve group : Succeeded
Test get group members : Succeeded, 37 users retrieved
Test user can authenticate : Succeeded
```