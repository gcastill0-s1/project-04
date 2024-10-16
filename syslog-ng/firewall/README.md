# Firewall Troubleshooting

## Security-Enhanced Linux (SELinux)

In some situations, the Linux firewall prevents the default behaviour with UDP traffic over port 514. 

For example, the following are typical errors in `/var/syslog`:
```bash
Sep 25 20:31:42 ip-172-31-10-3 systemd[1]: Starting System Logger Daemon...
Sep 25 20:31:42 ip-172-31-10-3 syslog-ng[41811]: [2024-09-25T20:31:42.401476] Error binding socket;
  addr='AF_INET(0.0.0.0:514)', error='Permission denied (13)'
```

In this case, we need to ascertain the status of the `Syslog` service as identified by the ports. Note that port 514 is not in the default configuration: 
```bash
[root@ip-172-31-10-3 conf.d]# semanage port -l | grep -i syslog
syslog_tls_port_t              tcp      6514, 10514
syslog_tls_port_t              udp      6514, 10514
syslogd_port_t                 tcp      601, 20514
syslogd_port_t                 udp      601, 20514
```

We double-check the status of the firewall. In this case, we're checking for a blocking behaviour - which we confirm with `sestatus`
```bash
[root@ip-172-31-10-3 conf.d]# sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      33
```

We enable the port via the firewall to allow traffic flow for syslog. Our desired port is 514, using the UDP protocol.
```bash
[root@ip-172-31-10-3 conf.d]# sudo semanage port -a -t syslogd_port_t -p udp 514
```
We confirm that port 514 is allowed via the firewall:
```bash
[root@ip-172-31-10-3 conf.d]# sudo semanage port -l | grep syslog
syslog_tls_port_t              tcp      6514, 10514
syslog_tls_port_t              udp      6514, 10514
syslogd_port_t                 tcp      601, 20514
syslogd_port_t                 udp      514, 601, 20514
```

## Uncomplicated Firewall (ufw)

Indicating message from `/var/log/messages`:

```bash
Oct  8 14:39:52 ip-10-0-2-114 kernel: [UFW BLOCK] IN=eth0 OUT= MAC=0a:ff:f4:c4:fe:89:0a:ff:d7:7e:56:a3:08:00 SRC=65.49.1.62 DST=10.0.2.114 LEN=40 TOS=0x00 PREC=0x00 TTL=239 ID=54321 PROTO=TCP SPT=43887 DPT=80 WINDOW=65535 RES=0x00 SYN URGP=0 
Oct  8 14:40:33 ip-10-0-2-114 kernel: [UFW BLOCK] IN=eth0 OUT= MAC=0a:ff:f4:c4:fe:89:0a:ff:d7:7e:56:a3:08:00 SRC=45.79.98.252 DST=10.0.2.114 LEN=44 TOS=0x00 PREC=0x00 TTL=240 ID=54321 PROTO=TCP SPT=35766 DPT=80 WINDOW=65535 RES=0x00 SYN URGP=0  
```

Start by checking the current status of UFW and the rules applied:

```bash
ubuntu@ip-10-0-2-114:~$ sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip
```

This will display all the active rules and whether UFW is enabled. Look for any rules that reference UDP port 514, which is the standard port for syslog over UDP.

Example output of the rule you're looking for:

```bash
514/udp                     ALLOW       Anywhere
```

If you do not see a rule for UDP port 514 and want to allow UDP syslog traffic, you can add a rule with the following command:

```bash
sudo ufw allow 514/udp
```