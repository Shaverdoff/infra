### OTHER OPTIMIZATION
#### change scheduler
```
# default linux scheduler is cfq and is not well for database access patterns. deadline is more appropriate scheduler and provides better latency guarantees. 
# Do that for all mountend volumes

# check default
cat /sys/block/sda/queue/scheduler
## none is best for SSD
## deadline is best for HDD
# set none
sudo echo none > /sys/block/sda/queue/scheduler
sudo echo none > /sys/block/nvme0n1/queue/scheduler
```
#### increase nr_requests
```
# default queue size for nr_requests is 128. This is number of read and write requests that can be queued before the next processing the request a read or write is put to sleep. Increasing the queue sizes reduces disk seeks by improving the write ordering.
sudo echo 1024 > /sys/block/sda/queue/nr_requests
```
#### disable add_random
```
# by default ssd/hdd contribute entrypy to the kernel random number pool, for ssd disable it.
# check default
cat /sys/block/sda/queue/add_random
cat /sys/block/nvme0n1/queue/add_random
# set 0
sudo echo 0 > /sys/block/sda/queue/add_random
sudo echo 0 > /sys/block/nvme0n1/queue/add_random
```
#### Disable rotational
```
# for SSD disks, rotational should be 0, to disable unneeded scheduler logic meant to reduce the number of seeks.
# check default
cat /sys/block/sda/queue/rotational
cat /sys/block/nvme0n1/queue/rotational
# set 0
sudo echo 0 > /sys/block/sda/queue/rotational
```



#### Decrease read_expire
```
# is the number of milliseconds in which a read request shoud be server. The default value is 500 and is relatively high, this value can be #lowered to 100
sudo echo 100 > /sys/block/sda/queue/iosched/read_expire
```
#### Adjust writed_starved
```
# number of read batches to process before processing a single write batch. default is 2.
sudo echo 4 > /sys/block/sda/queue/iosched/writed_starved
```
#### increase rq_affinity
```
# improve cpu perfomance - good for 16cpu cores or more.
sud echo 2 > /sys/block/sda/queue/rv_affinity
```
