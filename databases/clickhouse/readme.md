# CLICKHOUSE
# connect
clickhouse-client

# query
show databases;
SHOW DATABASES LIKE '%de%'
https://altinity.com/blog/2020/5/12/sql-for-clickhouse-dba
2021.10.06 09:47:45.673181 [ 1 ] {} <Error> Application: DB::Exception: A setting 'allow_experimental_multiple_joins_emulation' 
  appeared at top level in config /etc/clickhouse-server/config.xml. But it is user-level setting that should be located in users.xml
  inside <profiles> section for specific profile. You can add it to <profiles><default> if you want to change default value of this setting. 
  You can also disable the check - specify <skip_check_for_incorrect_settings>1</skip_check_for_incorrect_settings> in the main configuration file.
