# Message from curl
```
https://www.cloudsavvyit.com/289/how-to-send-a-message-to-slack-from-a-bash-script/
https://api.slack.com/apps/some_id/incoming-webhooks?
Go to the Incoming Webhooks and generate url for channel
curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World!"}' https://hooks.slack.com/services/SOME_TOKEN
```
