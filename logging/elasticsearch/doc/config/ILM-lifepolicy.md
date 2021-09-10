## LIFEPOLICY


# WITHOUT DATASTREAM
### 1. Policy
Go to ElasticSearch => Stack Management => Data => Index lifecycle policy => Create policy

#### ** Policy CLI**
go to Menu => Dev tools
```
# shard - это подпапка в индексе (индекс весит 400гб, может состоять либо из шарда(папки в 400гб), либо из 10 шардов по 40гб)
# segment - size of heap (RAM size for elk)
# max_primary_shard_size - set size of shard in mb,gb

# life policy
PUT _ilm/policy/rv-lifepolicy_all
{
  "policy": {
    "phases": {
      "hot": {
        "min_age": "0ms",
        "actions": {
          "rollover": {
            "max_primary_shard_size": "100mb",
            "max_age": "10d"
          },
          "forcemerge": {
            "max_num_segments": 1
          }
        }
      },
      "warm": {
        "min_age": "10d",
        "actions": {
          "readonly": {},
          "allocate": {
            "number_of_replicas": 0
          }
        }
      },
      "cold": {
        "min_age": "20d",
        "actions": {
          "set_priority": {
            "priority": 0
          }
        }
      },
      "delete": {
        "min_age": "30d",
        "actions": {
          "delete": {
            "delete_searchable_snapshot": true
          }
        }
      }
    }
  }
}
```
### 2. Index template
Menu => Stack Management => Index management => Index template => Create template
# ** CLI **
```

PUT _index_template/rv-index_template
{
  "template": {
    "aliases": {
      "rv-site_nginx": {}
    },
    "settings": {
      "index": {
        "lifecycle": {
          "name": "rv-lifepolicy_all",
          "rollover_alias": "rv-index_template"
        },
        "codec": "best_compression",
        "number_of_shards": "1",
        "number_of_replicas": "0"
      }
    }
  },
  "index_patterns": [
    "rv-site_nginx-*"
  ]
}


```

### 3. create new index nginx-000001 with alias nginx for index pattern alias - nginx
```
PUT rv-site_nginx-000001
{
  "aliases": {
    "rv-site_nginx": {
      "is_write_index": true
    }
  }
}

# second example!
# create new index with mappings status field = long (number) and remote_addr = ip
PUT rv-site_nginx-000001
{
  "aliases": {
    "nginx": {
      "is_write_index": true
    }
  },
  "mappings": {
    "properties": {
      "status": {
        "type": "long"
      },
      "remote_addr": {
        "type": "ip"
      }
    }
  }
}
```
### 4. create index pattern NGINX on alias nginx


### 5. Delete indexes
# delete data in index
```
POST rv-site_nginx-000001/_delete_by_query
{
  "query": {
    "match_all": {}
  }
}
```
# delete index
```
# for delete index, stop new dataflow, e.g. fluentbit
DELETE /rv-site_nginx-000001/_alias/nginx
DELETE /rv-site_nginx-000001

```

# OTHER
### 4. Применение шаблона ко всем существующим индексам
```
PUT rv-site_nginx-*/_settings
{
  "index.lifecycle.name": "rv-lifepolicy_all" 
}

rv-site_nginx-* - index pattern name
```
### 5. CHECK policy
```
GET rv-site_nginx-*/_ilm/explain
```
