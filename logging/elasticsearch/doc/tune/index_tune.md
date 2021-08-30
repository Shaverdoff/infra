# index.refresh_interval
```
# default is 1s
# get current settings
GET /kube/_settings

# change refresh_interval to 10s
PUT /kube/_settings
{
    "index" : {
        "refresh_interval" : "10s"
    }
}
```
# index.number_of_replicas 
```
# get current settings
GET /kube/_settings
PUT /kube/_settings
{
    "index" : {
        "number_of_replicas" : 0
    }
}
```

























