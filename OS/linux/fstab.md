# NFS MOUNT
```
# STATIC SITE (new nfs storage) CLUSTER
10.1.0.90:/Site_Static       /mnt/static_site/                     nfs       noatime         0 0
10.1.0.91:/Site_Static       /mnt/static_site/	       	       	   nfs       noatime	     0 0
#mount -t nfs 10.1.0.90:/Site_Static /mnt/static_site/
```
