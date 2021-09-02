# FIREWALLD
```

# create new service
#cp /usr/lib/firewalld/services/kibana.xml services/confluence.xml
nano services/confluence.xml
# create a new zone
firewall-cmd --permanent --new-zone=shakti
# list of zone
firewall-cmd --permanent --get-zones
# edit zone
# drop - drop every packet not matching any rule
nano /etc/firewalld/zones/shakti.xml
<?xml version="1.0" encoding="utf-8"?>
<zone target="DROP">
  <short>Shakti Zone Configuration</short>
  <description>All incomming connections are blocked by default. Only specific services are allowed.</description>
  <service name="ssh"/>
  <service name="confluence"/>
</zone>

# enable zones
firewall-cmd --reload
firewall-cmd --set-default-zone=shakti
firewall-cmd --get-default-zone
firewall-cmd --get-zone-of-interface=eth0
# change zone for interface, its will change line ZONE - /etc/sysconfig/network-scripts/ifcfg-<interface>.
firewall-cmd --zone=shakti --change-interface=eth0

# PUBLIC ZONE
<?xml version="1.0" encoding="utf-8"?>
<zone>
  <short>Public</short>
  <description>For use in public areas. You do not trust the other computers on networks to not harm your computer. Only selected incoming connections are accepted.</description>
  <service name="ssh"/>
  <service name="dhcpv6-client"/>
  <port protocol="tcp" port="8090"/>
  <port protocol="tcp" port="5432"/>
  <rule family="ipv4">
    <source address="10.10.7.10/32"/>
    <port protocol="tcp" port="5634"/>
    <accept/>
  </rule>
</zone>
```
