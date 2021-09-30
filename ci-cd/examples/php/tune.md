# PHP-FPM
```
# set to static (static used only 2 option - PM_MODE and MAX_CHILDREN)
PHP_PM_MODE: static
PHP_MAX_CHILDREN: 4000

dynamic - динамически изменяющееся число дочерних процессов, задаётся на основании следующих директив: pm.max_children, pm.start_servers, pm.min_spare_servers, pm.max_spare_servers.
```
