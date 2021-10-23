```
pvcreate /dev/sdb
vgcreate data /dev/sdb
lvcreate -l 100%FREE -n lv_data data
 
mkfs.xfs -n ftype=1 /dev/data/lv_data
echo "/dev/mapper/data-lv_data /data                       xfs     defaults        0 0" | sudo tee -a /etc/fstab >/dev/null
mkdir /data
mount /data
 
df -h
```
