
# INSTALL
## add repo
```
nano /etc/yum.repos.d/hashicorp.repo
[hashicorp]
name=Hashicorp Stable - $basearch
baseurl=https://rpm.releases.hashicorp.com/RHEL/$releasever/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://rpm.releases.hashicorp.com/gpg

[hashicorp-test]
name=Hashicorp Test - $basearch
baseurl=https://rpm.releases.hashicorp.com/RHEL/$releasever/$basearch/test
enabled=0
gpgcheck=1
gpgkey=https://rpm.releases.hashicorp.com/gpg
```
## install vault
```
yum install vault -y
```
## add config file
```
# MASTER
nano /etc/vault.d/vault.hcl
# -----------------------------------------------------------------------
#### Global configuration
# -----------------------------------------------------------------------
ui = "true"
max_lease_ttl = "768h"
default_lease_ttl = "768h"
disable_cache = true
disable_mlock = true
# -----------------------------------------------------------------------
#### Listener configuration
# -----------------------------------------------------------------------
listener "tcp" {
  address = "0.0.0.0:8200"
  cluster_address     = "0.0.0.0:8201"
  tls_cert_file = "/etc/ssl/certs/company.crt"
  tls_key_file  = "/etc/ssl/certs/company.key"
  tls_disable = false # enable tls
}

#-----------------------------------------------------------
### STORAGE backend
#-----------------------------------------------------------
storage "raft" {
  path = "/opt/vault/raft"
  node_id = "raft_node_1" # node id
}
#-----------------------------------------------------------
### AUTO-JOIN HA
#-----------------------------------------------------------
# main node
retry_join {
  leader_api_addr = "http://vault.company.com:8200"
  leader_ca_cert_file = "/etc/ssl/certs/company.crt"
  leader_client_cert_file = "/etc/ssl/certs/company.crt"
  leader_client_key_file = "/etc/ssl/certs/company.key"
}
# second node
retry_join {
  leader_api_addr = "http://vault-linode.company.com:8200"
  leader_ca_cert_file = "/etc/ssl/certs/company.crt"
  leader_client_cert_file = "/etc/ssl/certs/company.crt"
  leader_client_key_file = "/etc/ssl/certs/company.key"
}

# -----------------------------------------------------------------------
#### Cluster
# -----------------------------------------------------------------------
api_addr = "https://vault.company.com:8200" # node ip
cluster_addr = "https://vault.company.com:8201" # node ip
cluster_name = "shakti-vault"
raw_storage_endpoint     = true
disable_clustering = "false"
disable_sealwrap = true
disable_printable_check = true
plugin_directory = "/opt/vault/plugin"
# -----------------------------------------------------------------------
# Enable Prometheus metrics by default
# -----------------------------------------------------------------------
telemetry {
  prometheus_retention_time = "30s"
  disable_hostname          = false
}

# SLAVE

# -----------------------------------------------------------------------
#### Global configuration
# -----------------------------------------------------------------------
ui = "true"
max_lease_ttl = "768h"
default_lease_ttl = "768h"
disable_cache = true
disable_mlock = true
# -----------------------------------------------------------------------
#### Listener configuration
# -----------------------------------------------------------------------
listener "tcp" {
  address = "0.0.0.0:8200"
  cluster_address     = "0.0.0.0:8201"
  tls_cert_file = "/etc/ssl/certs/company.crt"
  tls_key_file  = "/etc/ssl/certs/company.key"
  tls_disable = false # enable tls
}

#-----------------------------------------------------------
### STORAGE backend
#-----------------------------------------------------------
storage "raft" {
  path = "/opt/vault/raft"
  node_id = "raft_node_2" # node id
}
#-----------------------------------------------------------
### AUTO-JOIN HA
#-----------------------------------------------------------
# main node
retry_join {
  leader_api_addr = "http://vault.company.com:8200"
  leader_ca_cert_file = "/etc/ssl/certs/company.crt"
  leader_client_cert_file = "/etc/ssl/certs/company.crt"
  leader_client_key_file = "/etc/ssl/certs/company.key"
}
# second node
retry_join {
  leader_api_addr = "http://vault-linode.company.com:8200"
  leader_ca_cert_file = "/etc/ssl/certs/company.crt"
  leader_client_cert_file = "/etc/ssl/certs/company.crt"
  leader_client_key_file = "/etc/ssl/certs/company.key"
}

# -----------------------------------------------------------------------
#### Cluster
# -----------------------------------------------------------------------
api_addr = "https://vault-linode.company.com:8200" # node ip
cluster_addr = "https://vault-linode.company.com:8201" # node ip
cluster_name = "shakti-vault"
raw_storage_endpoint     = true
disable_clustering = "false"
disable_sealwrap = true
disable_printable_check = true
plugin_directory = "/opt/vault/plugin"
# -----------------------------------------------------------------------
# Enable Prometheus metrics by default
# -----------------------------------------------------------------------
telemetry {
  prometheus_retention_time = "30s"
  disable_hostname          = false
}


```

## add folder with permissions
```
sudo mkdir /opt/raft
sudo chown -R vault:vault /opt/raft
```
## add systemd daemon
```
nano /etc/systemd/system/vault.service
[Unit]
Description="HashiCorp Vault - A tool for managing secrets"
Documentation=https://www.vaultproject.io/docs/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault.d/vault.hcl
StartLimitIntervalSec=60
StartLimitBurst=3

[Service]
User=root
Group=root
ProtectSystem=full
ProtectHome=read-only
PrivateTmp=yes
PrivateDevices=yes
SecureBits=keep-caps
AmbientCapabilities=CAP_IPC_LOCK
Capabilities=CAP_IPC_LOCK+ep
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK
NoNewPrivileges=yes
ExecStart=/usr/local/bin/vault server -config=/etc/vault.d/vault.hcl
ExecReload=/bin/kill --signal HUP $MAINPID
KillMode=process
KillSignal=SIGINT
Restart=on-failure
RestartSec=5
TimeoutStopSec=30
LimitNOFILE=65536
LimitMEMLOCK=infinity

[Install]
WantedBy=multi-user.target

```
## start service
```
ln -s /usr/bin/vault /usr/local/bin
systemctl daemon-reload
systemctl start vault
systemctl status vault
```
## go to url of master and init cluster
```
# ON MASTER
Create a new Raft cluster
mkdir -p /etc/vault.d/secret && cd /etc/vault.d/secret
vault operator init -key-shares=5 -key-threshold=3 -format=json > cluster.json
VAULT_UNSEAL_KEY=$(cat cluster.json | jq -r ".unseal_keys_b64[]")
echo $VAULT_UNSEAL_KEY
# unseal
vault operator unseal key1
vault operator unseal key2
vault operator unseal key3
vault status

echo "export VAULT_ADDR=https://vault.company.com:8200" ~/.bashrc
source ~/.bashrc

# ON SLAVE
echo "export VAULT_ADDR=https://vault-linode.company.com:8200" ~/.bashrc
source ~/.bashrc
vault operator raft join https://vault.company.com:8200
vault operator unseal

# on master
export VAULT_TOKEN= root.token from cluster.json
vault operator raft list-peers

https://vault.company.com:8200
```
