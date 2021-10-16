# drop old services
```
curl \
    --header "X-Consul-Token: AUTH_TOKEN" \
    -v -X PUT http://127.0.0.1:8500/v1/agent/service/deregister/selfyid-service-393069
```
