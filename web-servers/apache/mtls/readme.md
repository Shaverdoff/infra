# MTLS
```
SSLVerifyClient - require client cert or no (none,require,optional)
SSLVerifyDepth - depth for certs (default 10)

nano ssl.conf
SSLVerifyClient none  
SSLVerifyDepth  10
SSLCACertificateFile /etc/ssl/rv-ssl/ca.pem
<If "-R '10.0.0.0/8'">
SSLVerifyClient  none
SSLVerifyDepth 10
</If>
<ElseIf "-R '172.16.20.0/24'">
SSLVerifyClient  none
SSLVerifyDepth 10
</ElseIf>
<ElseIf "-R '172.16.20.49'">
SSLVerifyClient require
SSLVerifyDepth 10
</ElseIf>
<ElseIf "-R '178.176.74.197'">
SSLVerifyClient require
SSLVerifyDepth 10
</ElseIf>
#mkb
<ElseIf "-R '195.191.76.210'">
SSLVerifyClient  none
SSLVerifyDepth 10
</ElseIf>
<Else>
SSLVerifyClient none
SSLVerifyDepth 10
</Else>

```