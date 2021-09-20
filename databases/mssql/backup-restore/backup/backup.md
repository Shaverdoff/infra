Бэкап
Бэкап выполняется скриптом
Который создается с помощью Microsoft SQL Server Management Studio – правой кнопкой по БД – tasks – backup
Данный скрипт запускается через cmd скрипт.
chcp 1251
echo --------------------------- >> C:\backup\backup.log
echo Start Incr Backup %date% %time% >> C:\backup\backup.log
sqlcmd -S localhost\finupr -d CCFEA -U sa -P Finupr2017 -i C:\Backup\bin\full_day.sql >> C:\backup\backup.log
exit
echo Finish Incr Backup %date% %time% >> C:\backup\backup.log
