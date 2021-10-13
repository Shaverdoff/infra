!!! Migrate RocketChat to the Docker !!!

# on Server
```
# install rocketctl
bash -c "$(curl https://install.rocket.chat)"
# backup
rocketchatctl backup
systemctl stop rocketchat
mv /opt/Rocket.Chat /opt/Rocket.Chat-old
# update from source
curl -L https://releases.rocket.chat/latest/download -o /tmp/rocket.chat.tgz
curl -L  https://releases.rocket.chat/3.18.2/download -o /tmp/rocket.chat.tgz
tar -xzf /tmp/rocket.chat.tgz -C /tmp
cd /tmp/bundle/programs/server && npm install
sudo mv /tmp/bundle /opt/Rocket.Chat
sudo chown -R rocketchat:rocketchat /opt/Rocket.Chat
systemctl start rocketchat

# update with rocketchat tool
rocketchat update
####rocketchatctl install --root-url=https://rv-rocket --webserver=none --use-mongo --install-node --port=4000 --version=3.0.0

# manual run
/usr/local/n/versions/node/12.16.2/bin/node /var/lib/rocket.chat/bundle/main.js
/var/lib/rocket.chat/bundle/main.js

# how fix
Can't find migration version 128
mongo
use rocketchat
db.migrations.find()
db.migrations.update({"_id": "control"}, {"version": 197, "locked": false})

# Failed at step CHDIR spawning /usr/local/n/versions/node/12.16.2/bin/node: No such file or directory
setfacl -Rm u:'rocketchat:rwx' /usr/local/n/versions/node/12.16.2/bin/node
sudo chown -R rocketchat:rocketchat /opt/Rocket.Chat


# ALSO UPGRADE NPM NODE
sudo n install 12.18.4
# service
nano /etc/systemd/system/rocketchat.service
[Unit]
Description=Rocket.Chat Server
After=syslog.target
After=network.target

[Service]
Type=simple
#Restart=always
StandardOutput=syslog
SyslogIdentifier=RocketChat
#User=rocketchat
#Group=rocketchat
User=root
Group=root
Environment=MONGO_URL=mongodb://127.0.0.1:27017/rocketchat
Environment=MONGO_OPLOG_URL=mongodb://127.0.0.1:27017/local
Environment=ROOT_URL=https://chat.company.ru
Environment=PORT=3000
WorkingDirectory=/opt/Rocket.Chat
ExecStart=/usr/local/n/versions/node/12.18.4/bin/node /opt/Rocket.Chat/main.js
 [Install]
WantedBy=multi-user.target
Restore mongo db
mongorestore --host localhost:27017 --db rocketchat --archive --gzip < /tmp/dump_1605856513.gz

```
