Sep 25 20:31:42 ip-172-31-10-3 systemd[1]: Starting System Logger Daemon...
Sep 25 20:31:42 ip-172-31-10-3 syslog-ng[41811]: [2024-09-25T20:31:42.401476] Error binding socket; addr='AF_INET(0.0.0.0:5515)', error='Permission denied (13)'

[root@ip-172-31-10-3 conf.d]# semanage port -l | grep -i syslog
syslog_tls_port_t              tcp      6514, 10514
syslog_tls_port_t              udp      6514, 10514
syslogd_port_t                 tcp      601, 20514
syslogd_port_t                 udp      514, 601, 20514

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

[root@ip-172-31-10-3 conf.d]# sudo semanage port -a -t syslogd_port_t -p udp 5515

[root@ip-172-31-10-3 conf.d]# sudo semanage port -l | grep syslog
syslog_tls_port_t              tcp      6514, 10514
syslog_tls_port_t              udp      6514, 10514
syslogd_port_t                 tcp      601, 20514
syslogd_port_t                 udp      5515, 514, 601, 20514