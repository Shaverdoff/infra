# WINDOWS CI
```
Переменные через %VAR%
---
stages:
  - prod

prod:
  stage: prod
  before_script:
   - CHCP 65001 
  script:
    - 'if not exist j:\ (net use j: \\RV-GIS\lightbox_frontend) '
    - 'cd /d J:\'
    #- git fetch -q --all user:token
    - echo %CI_JOB_STAGE%
    - git fetch https://%user%:%token%@git.company.ru/rv_dev/lightbox_frontend.git
    - git reset -q --hard %CI_COMMIT_SHA%
    - git clean -qdxf
  #when: manual
  allow_failure: false
  only:
   - master
  tags:
    - lightbox_frontend


Установил раннер с executor = shell работает в powershell
stages:
- windows

windows:
  stage: windows
  before_script:
   - CHCP 65001 # кодировка для винды
  script:
  - Remove-Variable CI #unset CI 
  - dotnet publish Athena.ClientUI/Athena.ClientUI.csproj -o C:\inetpub\wwwroot\Athena\ --no-self-contained --configuration Release
  - Start-Process powershell -Verb runAs # повышение прав
  - iisreset /RESTART # рестарт IIS
  tags:
  - shell_windows
Помогло при билде REACT-SCRIPTS – был с варнингами.
Падало потому что CI сервер выставляет это в TRUE
Treating warnings as errors because process.env.CI = true
Remove-Variable CI #unset CI
Изменение прав в текущем окно для повершелл
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))

{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}

DELETE DIR 
remove-Item –path E:\athena1 –recurse
Remove-Item -path E:\athena1\ -recurse -Force
```