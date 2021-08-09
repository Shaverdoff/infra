# Alerts and targets

Add targets to config/prometheus/targets folder

Add alerts to config/prometheus/rules folder

# Examples:

Targets:
```
####################
# RV-SITE
####################
## MEMCACHED
- targets:
  - rv-site-sql05:9150 
  - rv-site-sql06:9150
  labels:
    tier: site
    env: prod
    job: memcached
    tag: "RV-SITE_memcached"
```

Rules:
```
- alert: Memcached Down
  annotations:
    description: No idle memcached proc on {{ $labels.instance}} more than 2 minutes.
    summary: No idle memcached proc on {{ $labels.instance}}
  expr: memcached_up{env="prod", tag="RV-SITE_memcached"} == 0
  for: 2m
  labels:
    severity: critical
    tag: "{{ $labels.tag }}"    
```

# Grafana LDAP
***
| Role  | AD Group      |
|-------|---------------|
| Admin | Grafana_Admin |
| Users | All AD users  |



