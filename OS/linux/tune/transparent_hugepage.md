# DISABLE transparent hugepage
```
# BETTER DISABLE IT FOR REDIS/MEMCACHED/COUCHBASE DATABASES

# CHECK enabled or not
cat /sys/kernel/mm/transparent_hugepage/enabled
[always] madvise never

# check current options
grub2-editenv - list | grep kernelopts
kernelopts=root=/dev/mapper/cs-root ro crashkernel=auto resume=/dev/mapper/cs-swap rd.lvm.lv=cs/root rd.lvm.lv=cs/swap rhgb quiet

# Update GRUB2 to disable Transparent HugePages (THP)
### Here we must append transparent_hugepage=never at the end of kernelopts to disable transparent hugepages. This will modify kernelopts content in /boot/grub2/grubenv file.
grub2-editenv - set "$(grub2-editenv - list | grep kernelopts) transparent_hugepage=never"

# check current options
grub2-editenv - list | grep kernelopts
kernelopts=root=/dev/mapper/cs-root ro crashkernel=auto resume=/dev/mapper/cs-swap rd.lvm.lv=cs/root rd.lvm.lv=cs/swap rhgb quiet  transparent_hugepage=never


# REBOOT
reboot

# CHECK enabled or not
cat /sys/kernel/mm/transparent_hugepage/enabled
always madvise [never]
```
