# UPGRADE REDMINE 3.1 to 4.0.5
```
Делаем снэпшот ВМ
wget https://www.redmine.org/releases/redmine-4.0.5.tar.gz
tar -xvf redmine-4.0.5.tar.gz


cp /var/www/redmine/config/database.yml /var/www/redmine-4.0.5/config
cp /var/www/redmine/config/configuration.yml /var/www/redmine-4.0.5/config
cp -r /var/www/redmine/files/* /var/www/redmine-4.0.5/files/
cp -r /var/www/redmine/plugins/* /var/www/redmine-4.0.5/plugins/

UPGRADE RUBY
rvm list known
gem update --system

INSTALL PLUGIN
cp plugin into plugin_dir redmine
cd /var/www/redmine
bundle install --without development test --no-deployment
bundle exec rake redmine:plugins NAME=redmine_contacts RAILS_ENV=production

# плагин вставки из буфера не работал - потому что прав не хватает на папку
chmod -R 777 /var/www/redmine


#Redmine delete plugins
take name from redmine folder/plugins - example redmine_checklists
run this command in redmine folder
bundle exec rake redmine:plugins:migrate NAME=redmine_checklists VERSION=0 RAILS_ENV=production
delete redmine plugin from plugins folder

restart webserver
update redmine
after all dont worked settings
chmod 777 -R /var/www/redmine/logs
chmod 777 -R /var/www/redmine/tmp
chmod 777 -R /var/www/redmine/files
```
# codeclimate-test-reporter
```
gem install codeclimate-test-reporter -v 1.0.9
https://libraries.io/rubygems/codeclimate-test-reporter
```