# GITLAB TO JIRA

## 1 for premium gitlab
```
Login under admin
Application => Add new application
Name - Jira
Redirect url - http://gitlab.company.ru/login/oauth/callback
http://gitlab.company.ru – your url gitlab
/login/oauth/callback – add this after your url
Scopes – api
Нажмите Save application. Вы увидите сгенерированные значения Application Id и Secret. Скопируйте эти значения, которые вы будете использовать на стороне конфигурации Jira.
Application ID
application_token_id
Secret
secret_token_id

В Jira перейдите в « Настройки Jira»> «Приложения»> Интеграция «Учетные записи DVCS» , затем нажмите « Link GitHub Enterprise», чтобы начать создание новой интеграции. (Мы притворяемся GitHub в этой интеграции, пока Jira не получит дальнейшую поддержку платформы.)
HOST – GITHUB ENTERPRISE
Team or User account – gitlab
Host url - http://gitlab.company.ru/
Client ID 
application_token_id
Client secret 
secret_token_id
```
2 standart gitlab
Go Gitlab => Admin Area => Service templates => Jira
Check checkbox – Active, Commit, Merge request
Web url - http://gitlab_ip:8080
Jira API URL - http://jira_ip:8080
Username or Email – gitlab
Enter new password or api token QWE123qwe

Go in Jira
Create user jira with admin access
DONE!

jira gitlab integration
in gitlab go project settings/integrations/jira - add url user and password
in jira in project settings give permission add comment to your user integration with gitlab
commit in gitlab with comment SUP-8 #comment test where sup-8 it's id issue
```