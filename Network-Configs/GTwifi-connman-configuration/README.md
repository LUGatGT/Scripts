# Connman configuration with GTwifi wireless
## WPA2 Enterprise, PEAP, and MS-CHAPv2

`connman` https://01.org/connman

### Procedure
1. Create a `*.config` file in `/var/lib/connman/`.
`# touch /var/lib/connman/gtwifi.config`

2. `chmod` so that only root has read/write access to the file since credentials will be stored in the file
`# chmod 0600 /var/lib/connman/gtwifi.config`

3. Inside `gtwifi.config`:

```
[service_peap]
Type=wifi
Name=GTwifi
EAP=peap
CACertFile=/etc/ssl/certs/AddTrust_External_Root.pem
Identity=gburdell3
Phase2=MSCHAPV2
Passphrase=hunter2
Security=ieee8021x
```

Identity and passphrase will be your GT account and password, respectively.
I don't know if you really need the CACertFile line.

* Restart connman service/daemon.

### Credits, Sources, etc.
http://git.kernel.org/cgit/network/connman/connman.git/tree/doc/config-format.txt
<br>
https://wiki.archlinux.org/index.php/Connman
