## LIFEPOLICY


# WITHOUT DATASTREAM
### 1. Policy
Go to ElasticSearch => Stack Management => Data => Index lifecycle policy => Create policy

#### ** Policy CLI**
go to Menu => Dev tools
```
# life policy
PUT _ilm/policy/rv-lifepolicy
{
  "policy": {
    "phases": {
      "hot": {
        "actions": {
          "rollover": {
            "max_age": "30d",
            "max_size": "50gb"
          },
          "set_priority": {
            "priority": 100
          },
          "forcemerge": {
            "max_num_segments": 1
          }
        },
        "min_age": "0ms"
      },
      "warm": {
        "min_age": "30d",
        "actions": {
          "set_priority": {
            "priority": 50
          },
          "shrink": {
            "number_of_shards": 1
          },
          "allocate": {
            "number_of_replicas": 1
          },
          "readonly": {}
        }
      },
      "cold": {
        "min_age": "40d",
        "actions": {
          "set_priority": {
            "priority": 0
          }
        }
      },
      "delete": {
        "min_age": "50d",
        "actions": {
          "delete": {}
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
# Index template for index - NGINX
PUT _index_template/nginx
{
  "template": {
    "settings": {
      "index": {
        "lifecycle": {
          "name": "rv-lifepolicy",
          "rollover_alias": "nginx"
        },
        "number_of_shards": "1",
        "auto_expand_replicas": "0-1",
        "number_of_replicas": "0"
      }
    }
  },
  "index_patterns": [
    "nginx-*"
  ],
  "composed_of": []
}

```

### 3. create new index nginx-000001 with alias nginx for index pattern alias - nginx
```
PUT nginx-000001
{
  "aliases": {
    "nginx": {
      "is_write_index": true
    }
  }
}
```
### 4. create index pattern NGINX on alias nginx


### 5. Delete indexes
# delete data in index
```
POST nginx-000001/_delete_by_query
{
  "query": {
    "match_all": {}
  }
}
```
# delete index
```
DELETE /nginx
DELETE /nginx-000001
DELETE /nginx-000001/_alias/nginx
```

# OTHER
### 4. Применение шаблона ко всем существующим индексам
```
PUT td*/_settings
{
  "index.lifecycle.name": "lifecycle-policy" 
}

td*/_ - index pattern name
```
### 5. CHECK policy
```
GET td*/_ilm/explain
```
