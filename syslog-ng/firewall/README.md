# Firewall Troubleshooting

In some situations, the Linux firewall prevents the default behaviour with UDP traffic over port 514. 

For example, the following are typical errors in `/var/syslog`:
```bash
Sep 25 20:31:42 ip-172-31-10-3 systemd[1]: Starting System Logger Daemon...
Sep 25 20:31:42 ip-172-31-10-3 syslog-ng[41811]: [2024-09-25T20:31:42.401476] Error binding socket; addr='AF_INET(0.0.0.0:514)', error='Permission denied (13)'
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