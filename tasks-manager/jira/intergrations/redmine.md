```
https://confluence.atlassian.com/adminjiraserver/importing-data-from-csv-938847533.html
# Подготовка REDMINE - change type date
Администрирование/Настройка
Формат даты
dd/MM/yyyy
в redmine заходим в задачи http://redmine_ip/issues
внизу экпорт в .csv
выбираем поля (Все столбцы и описание)


# in JIRA
Create new project and call him REDMINE - take basic type

go to Settings/Administration/system/import csv
# SETTINGS
Суффикс почтовых адресов для новых пользователей @vko-simvol.ru
Формат даты dd/MMM/yy h:mm a - проверьте формат данных в redmine (задается в настройках)

File encoding UTF-8
CSV Delimiter ;
Import to Project REDMINE
E-mail Suffix for New Users @vko-simvol.ru
Date format dd/MM/yyyy
Сопоставляем поля
Что бы вы хотели сделать с созданными пользователями?
Неактивные

ERRORS
Загруженный файл CSV содержит символы, не принадлежащие ASCII. Убедитесь, что задана правильная кодировка.
решение - выбрать разделитель другой ;

Ошибки при импорте
Status Открытый cannot be found in JIRA neither by name and id
Status [ Open ] does not have a linked step in the [ Software Simplified Workflow for Project RED ] workflow. Please map to a different status.
Решение
Создаем статус
Администрирование/ISSUE/STATUSES - лучше переименовать в redmine статусы для соответствия в jira - http://redmine_ip/issue_statuses
Потом добавляем отсутствующие статусы в Администрирование/ISSUE/workflows находим наш проект EDIT - ADD status
```