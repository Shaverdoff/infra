# COMMON TUNING
```
# check current config
sysctl -a | grep tcp_low_latency

nano /etc/sysctl.conf
##########
# RV
###########
# ===========================================
# Networking
# ===========================================
# When the server has to cycle through a high volume of TCP connections,
# it can build up a large number of connections in TIME_WAIT state.
# TIME_WAIT means a connection is closed but the allocated
# resources are yet to be released. Setting this directive to 1
# will tell the kernel to try to recycle the allocation
# for a new connection when safe to do so.
# This is cheaper than setting up a new connection from scratch.
net.ipv4.tcp_tw_reuse = 1

# FOR DB better use 3!
# The minimum number of seconds that must elapse before
# a connection in TIME_WAIT state can be recycled.
# Lowering this value will mean allocations will be recycled faster.
net.ipv4.tcp_fin_timeout = 10

# =====================================================
# MEMORY
# ==================================================
# Disables NUMA zone relcaim algorithm. This tends to decrease read latencies.
vm.zone_reclaim_mode = 0

# =====================================================
# DISK
# ==================================================
# instruct the kernel to swap only as a last resort
vm.swappiness = 1
# Increase size of file handles and inode cache
fs.file-max = 105536139
```
