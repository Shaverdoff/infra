# INGRESS CONTROLLER OPTIMIZATION
### GZIP
```
kubectl edit configmap -n ingress-nginx ingress-nginx-controller
#### add this
data: # ADD IF NOT PRESENT
  use-gzip: "true" # ENABLE GZIP COMPRESSION
  gzip-types: "*" # SPECIFY MIME TYPES TO COMPRESS ("*" FOR ALL) 

# how check it
Checking with Developer tools with a browser of your choosing:
Chrome -> F12 -> Network -> Go to site (or refresh) and press on example file (look on Response Header):
CONTEND-ENCODING: gzip
```
### Optimize Sysctl
```
# Changes:
Backlog Queue setting net.core.somaxconn from 128 to 32768
Ephemeral Ports setting net.ipv4.ip_local_port_range from 32768 60999 to 1024 65000

kubectl patch deployment -n ingress-nginx ingress-nginx-controller \
  --patch="$(curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/docs/examples/customization/sysctl/patch.json)"
```
