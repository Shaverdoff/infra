# clear space from old images
```
docker exec -it gitlab bash
# collect nonusing tags
gitlab-ctl registry-garbage-collect or gitlab-ctl registry-garbage-collect /path/to/config.yml

# drop nonused images
gitlab-ctl registry-garbage-collect -m
```





