# TP6 : Travail autour de la solution NextCloud

## Module 1 : Reverse Proxy

### I. Setup


🌞 On utilisera NGINX comme reverse proxy

```c
[it5@proxy ~]$ sudo systemctl status nginx | head -n 5
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
     Active: active (running) since Mon 2023-01-16 09:45:43 CET; 59s ago
    Process: 1399 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 1400 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)

[it5@proxy ~]$ sudo ss -alptn | grep nginx
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=1403,fd=6),("nginx",pid=1402,fd=6))
LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=1403,fd=7),("nginx",pid=1402,fd=7))


[it5@proxy ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[it5@proxy ~]$ sudo firewall-cmd --reload
success


[it5@proxy ~]$ ps -ef | grep nginx
//root        1402       1  0 09:45 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       1403    1402  0 09:45 ?        00:00:00 nginx: worker process
//it5         1461    1218  0 09:49 pts/0    00:00:00 grep --color=auto nginx

[it5@proxy ~]$ curl 192.168.56.132:80 | tail -n 5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0   676k      0 --:--:-- --:--:-- --:--:--  676k
      <a href="https://nginx.org">NGINX&trade;</a> is a registered trademark of <a href="https://">F5 Networks, Inc.</a>.
      </footer>

  </body>
</html>
```

🌞 Configurer NGINX

```c
[it5@proxy etc]$ cat nginx/default.d/useit.conf
server {
...
proxy_pass http://192.168.56.131:80;
...
      return 301 $scheme://$host/remote.php/dav;
}

[it5@web config]$ sudo cat config.php |head -n 10
<?php
$CONFIG = array (
  'instanceid' => 'ocmk8v64fucm',
  'passwordsalt' => 'LOdEvz/O8VHCv7d6hU4srJti1jwcEn',
  'secret' => 'ppe/fHQi5HQhmiDa7xYsjv7Tsya9YopZ43cvLt89CjiNPvOQ',
  'trusted_domains' =>
  array (
    0 => 'web.tp5.linux',
    1 => '192.168.56.132',
  ),

```

🌞 Faites en sorte de

```c
[it5@web srv]$ sudo firewall-cmd --set-default-zone=drop
success
[it5@web srv]$ sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.56.132" accept'
success
[it5@web srv]$ sudo firewall-cmd --reload
success
[it5@web srv]$ sudo firewall-cmd --listall
usage: see firewall-cmd man page
firewall-cmd: error: unrecognized arguments: --listall
[it5@web srv]$ sudo firewall-cmd --list-all
drop (active)
  target: DROP
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources:
  services:
  ports:
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
        rule family="ipv4" source address="192.168.56.132" accept

```

🌞 Une fois que c'est en place
```c
33603@LAPTOP-VPED60LK MINGW64 ~
$ ping 192.168.56.131

Envoi d'une requ▒te 'Ping'  192.168.56.131 avec 32 octets de donn▒es▒:
D▒lai d'attente de la demande d▒pass▒.

Statistiques Ping pour 192.168.56.131:
    Paquets▒: envoy▒s = 1, re▒us = 0, perdus = 1 (perte 100%),
Ctrl+C
33603@LAPTOP-VPED60LK MINGW64 ~
$ ping 192.168.56.132

Envoi d'une requ▒te 'Ping'  192.168.56.132 avec 32 octets de donn▒es▒:'
R▒ponse de 192.168.56.132▒: octets=32 temps<1ms TTL=64
R▒ponse de 192.168.56.132▒: octets=32 temps<1ms TTL=64

Statistiques Ping pour 192.168.56.132:
    Paquets▒: envoy▒s = 2, re▒us = 2, perdus = 0 (perte 0%),
Dur▒e approximative des boucles en millisecondes :
    Minimum = 0ms, Maximum = 0ms, Moyenne = 0ms
```
desolé pour les accents non affiché

## II. HTTPS





# Module 2 : Sauvegarde du système de fichiers


## I. Script de backup

### 1. Ecriture du script

🌞 Ecrire le script bash


[le script](./Tp6-linux/tp6_backup.sh)
```c
[it5@web ~]$ sudo -u backup bash /srv/tp6_backup.sh
  adding: var/www/tp5_nextcloud/config/ (stored 0%)
  adding: var/www/tp5_nextcloud/config/CAN_INSTALL (stored 0%)
  adding: var/www/tp5_nextcloud/config/config.sample.php (deflated 68%)
  adding: var/www/tp5_nextcloud/config/.htaccess (deflated 60%)
  adding: var/www/tp5_nextcloud/config/config.php (deflated 44%)
  adding: var/www/tp5_nextcloud/data/ (stored 0%)
  adding: var/www/tp5_nextcloud/data/.htaccess (deflated 56%)
  adding: var/www/tp5_nextcloud/data/index.html (stored 0%)
  adding: var/www/tp5_nextcloud/data/nextcloud.log (deflated 78%)
  adding: var/www/tp5_nextcloud/themes/ (stored 0%)
  adding: var/www/tp5_nextcloud/themes/example/ (stored 0%)
  adding: var/www/tp5_nextcloud/themes/example/core/ (stored 0%)
  adding: var/www/tp5_nextcloud/themes/example/core/img/ (stored 0%)
  adding: var/www/tp5_nextcloud/themes/example/core/img/favicon.svg (deflated 42%)
  adding: var/www/tp5_nextcloud/themes/example/core/img/logo.png (deflated 18%)
  adding: var/www/tp5_nextcloud/themes/example/core/img/favicon-touch.png (deflated 2%)
  adding: var/www/tp5_nextcloud/themes/example/core/img/logo-icon.png (stored 0%)
  adding: var/www/tp5_nextcloud/themes/example/core/img/logo-mail.gif (deflated 0%)
  adding: var/www/tp5_nextcloud/themes/example/core/img/favicon-touch.svg (deflated 47%)
  adding: var/www/tp5_nextcloud/themes/example/core/img/favicon.png (stored 0%)
  adding: var/www/tp5_nextcloud/themes/example/core/img/logo.svg (deflated 55%)
  adding: var/www/tp5_nextcloud/themes/example/core/img/logo-icon.svg (deflated 43%)
  adding: var/www/tp5_nextcloud/themes/example/core/img/favicon.ico (deflated 80%)
  adding: var/www/tp5_nextcloud/themes/example/core/css/ (stored 0%)
  adding: var/www/tp5_nextcloud/themes/example/core/css/server.css (deflated 65%)
  adding: var/www/tp5_nextcloud/themes/example/defaults.php (deflated 64%)
  adding: var/www/tp5_nextcloud/themes/README (deflated 43%)
nextcloud1673886786

```

### 3. Service et timer

🌞 Créez un service système qui lance le script

```c
[it5@web ~]$ sudo cat /etc/systemd/system/backup.service
[UNIT]
Description=faire une backup du fichier tp5-nextcloud

[Service]
Type=oneshot
ExecStart=/bin/bash /srv/tp6_backup.sh

[Install]
WantedBy=multi-user.target

[it5@web backup]$ ls
[it5@web backup]$ sudo systemctl start backup
[it5@web backup]$ ls
nextcloud1673887331.zip

```

🌞 Créez un timer système qui lance le service à intervalles réguliers

```c
[it5@web srv]$ cat /etc/systemd/system/backup.timer
[Unit]
Description=Run service X

[Timer]
OnCalendar=*-*-* 4:00:00

[Install]
WantedBy=timers.target

```


🌞 Activez l'utilisation du timer

```c
[it5@web srv]$ sudo systemctl daemon-reload
[it5@web srv]$ sudo systemctl start backup.timer
[it5@web srv]$ sudo systemctl enable backup.timer
Created symlink /etc/systemd/system/timers.target.wants/backup.timer → /etc/systemd/system/backup.timer.
[it5@web srv]$ sudo systemctl status backup.timer
● backup.timer - Run service X
     Loaded: loaded (/etc/systemd/system/backup.timer; enabled; vendor preset: disabled)
     Active: active (waiting) since Mon 2023-01-16 18:10:32 CET; 2min 35s ago
      Until: Mon 2023-01-16 18:10:32 CET; 2min 35s ago
    Trigger: Tue 2023-01-17 04:00:00 CET; 9h left
   Triggers: ● backup.service

Jan 16 18:10:32 web.tp5.linux systemd[1]: Started Run service X.

[it5@web srv]$ sudo systemctl list-timers
NEXT                        LEFT          LAST                        PASSED       UNIT                         ACTIVATES             >
Mon 2023-01-16 18:52:30 CET 37min left    Mon 2023-01-16 16:59:16 CET 1h 15min ago dnf-makecache.timer          dnf-makecache.service
Tue 2023-01-17 00:00:00 CET 5h 45min left Mon 2023-01-16 09:22:07 CET 8h ago       logrotate.timer              logrotate.service
Tue 2023-01-17 04:00:00 CET 9h left       n/a                         n/a          backup.timer                 backup.service
Tue 2023-01-17 09:37:09 CET 15h left      Mon 2023-01-16 09:37:09 CET 8h ago       systemd-tmpfiles-clean.timer systemd-tmpfiles-clean>

4 timers listed.

```
## II. NFS

### 1. Serveur NFS

🌞 Préparer un dossier à partager sur le réseau

```c
[it5@storage ~]$ sudo mkdir /srv/nfs_shares
[sudo] password for it5:
[it5@storage ~]$ sudo mkdir /srv/nfs_shares/web.tp6.linux
```

🌞 Installer le serveur NFS
```c
[it5@storage ~]$ sudo dnf install nfs-utils
Rocky Linux 9 - BaseOS                           10 kB/s | 3.6 kB     00:00
Rocky Linux 9 - BaseOS                          2.1 MB/s | 1.7 MB     00:00
[it5@storage ~]$ sudo nano /etc/exports
[it5@storage ~]$ sudo cat /etc/exports
/srv/nfs_shares/web.tp6.linux/ 192.168.56.131(rw,sync,no_subtree_check)

[it5@storage ~]$ sudo systemctl enable nfs-server
Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service.
[it5@storage ~]$ sudo systemctl start nfs-server
[it5@storage ~]$ sudo systemctl status nfs-server
● nfs-server.service - NFS server and services
[it5@storage ~]$ sudo firewall-cmd --permanent --add-service=nfs
success
[it5@storage ~]$ sudo firewall-cmd --permanent --add-service=mountd
success
[it5@storage ~]$ sudo firewall-cmd --permanent --add-service=rpc-bind
success
[it5@storage ~]$ sudo firewall-cmd --reload
success

```

### 2. Client NFS

🌞 Installer un client NFS sur web.tp6.linux

```c

```

# Module 3 : Fail2Ban

🌞 Faites en sorte que :

```c
[it5@db ~]$ sudo dnf install epel-release
[it5@db ~]$ sudo dnf install fail2ban fail2ban-firewalld
[it5@db ~]$ sudo systemctl start fail2ban
[it5@db ~]$ sudo systemctl status fail2ban
● fail2ban.service - Fail2Ban Service
     Loaded: loaded (/usr/lib/systemd/system/fail2ban.service; disabled; vendor preset: disabled)
     Active: active (running) since Wed 2023-01-18 00:35:09 CET; 7s ago
       Docs: man:fail2ban(1)
    Process: 12584 ExecStartPre=/bin/mkdir -p /run/fail2ban (code=exited, status=0/SUCCESS)
   Main PID: 12585 (fail2ban-server)
      Tasks: 3 (limit: 5877)
     Memory: 10.3M
        CPU: 60ms
     CGroup: /system.slice/fail2ban.service
             └─12585 /usr/bin/python3 -s /usr/bin/fail2ban-server -xf start

Jan 18 00:35:08 db.linux.tp6 systemd[1]: Starting Fail2Ban Service...
Jan 18 00:35:09 db.linux.tp6 systemd[1]: Started Fail2Ban Service.
Jan 18 00:35:09 db.linux.tp6 fail2ban-server[12585]: 2023-01-18 00:35:09,059 fail2ban.configreader   [12585]: WARNING 'allowipv6' not defined in 'Definition'. Using default one: 'auto'
Jan 18 00:35:09 db.linux.tp6 fail2ban-server[12585]: Server ready
[it5@db ~]$ sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
[it5@db ~]$ sudo mv /etc/fail2ban/jail.d/00-firewalld.conf /etc/fail2ban/jail.d/00-firewalld.local
[it5@db ~]$ sudo systemctl restart fail2ban

[it5@db ~]$ sudo cat /etc/fail2ban/jail.d/sshd.local
[sshd]
enabled = true

# Override the default global configuration
# for specific jail sshd
bantime = 1d
maxretry = 3
findtime = 1m
[it5@db ~]$ sudo systemctl restart fail2ban
[it5@db ~]$ sudo fail2ban-client get sshd maxretry
3
[it5@db ~]$ sudo fail2ban-client get sshd findtime
60
[it5@db ~]$ sudo fail2ban-client status sshd
Status for the jail: sshd
|- Filter
|  |- Currently failed:	0
|  |- Total failed:	3
|  `- Journal matches:	_SYSTEMD_UNIT=sshd.service + _COMM=sshd
`- Actions
   |- Currently banned:	1
   |- Total banned:	1
   `- Banned IP list:	172.16.72.11
[it5@db ~]$ sudo firewall-cmd --list-all | grep rule
  rich rules: 
	rule family="ipv4" source address="172.16.72.11" port port="ssh" protocol="tcp" reject type="icmp-port-unreachable"
[it5@db ~]$ sudo fail2ban-client unban 172.16.72.11
1
[it5@db ~]$ sudo fail2ban-client status sshd
Status for the jail: sshd
|- Filter
|  |- Currently failed:	0
|  |- Total failed:	0
|  `- Journal matches:	_SYSTEMD_UNIT=sshd.service + _COMM=sshd
`- Actions
   |- Currently banned:	0
   |- Total banned:	1
   `- Banned IP list:	
```


# Module 4 : Monitoring

🌞 Installer Netdata

```c
[it5@web backup]$ sudo dnf install wget
[it5@web backup]$ sudo wget -O /tmp/netdata-kickstart.sh https://my-netdata.io/kickstart.sh && sh /tmp/netdata-kickstart.sh
[it5@web backup]$ sudo firewall-cmd --permanent --add-port=19999/tcp
success
[it5@web backup]$ sudo firewall-cmd --reload
success
[it5@web backup]$ ss -lapten | grep netdata                         
LISTEN    0      4096              0.0.0.0:19999            0.0.0.0:*     uid:989 ino:45722 sk:5 cgroup:/system.slice/netdata.service <-> 


```

🌞 Une fois Netdata installé et fonctionnel, déterminer :

```c
[it5@web backup]$ ps -ef | grep netdata
netdata     4166       1  1 02:03 ?        00:00:09 /usr/sbin/netdata -P /run/netdata/netdata.pid -D
netdata     4168    4166  0 02:03 ?        00:00:00 /usr/sbin/netdata --special-spawn-server
netdata     4381    4166  0 02:03 ?        00:00:00 bash /usr/libexec/netdata/plugins.d/tc-qos-helper.sh 1
netdata     4394    4166  1 02:03 ?        00:00:05 /usr/libexec/netdata/plugins.d/apps.plugin 1
netdata     4396    4166  0 02:03 ?        00:00:02 /usr/libexec/netdata/plugins.d/go.d.plugin 1
[it5@web backup]$ ss -lapten | grep netdata
LISTEN    0      4096            127.0.0.1:8125             0.0.0.0:*     uid:989 ino:46705 sk:4 cgroup:/system.slice/netdata.service <->                              
LISTEN    0      4096              0.0.0.0:19999            0.0.0.0:*     uid:989 ino:45722 sk:5 cgroup:/system.slice/netdata.service <->                              
ESTAB     0      0            172.16.72.11:19999        172.16.72.1:53094 timer:(keepalive,114min,0) uid:989 ino:52220 sk:54 cgroup:/system.slice/netdata.service <->  
ESTAB     0      0               127.0.0.1:38372          127.0.0.1:80    timer:(keepalive,2.450ms,0) uid:989 ino:56662 sk:11e cgroup:/system.slice/netdata.service <->
LISTEN    0      4096                [::1]:8125                [::]:*     uid:989 ino:46704 sk:86 cgroup:/system.slice/netdata.service v6only:1 <->                    
LISTEN    0      4096                 [::]:19999               [::]:*     uid:989 ino:45723 sk:87 cgroup:/system.slice/netdata.service v6only:1 <->                    
ESTAB     0      0                   [::1]:46368              [::1]:80    timer:(keepalive,450ms,0) uid:989 ino:56642 sk:126 cgroup:/system.slice/netdata.service <-> 
[it5@web backup]$ sudo journalctl -xe -u netdata -f
Jan 18 02:03:11 web.linux.tp6 systemd[1]: Starting Real time performance monitoring...
░░ Subject: A start job for unit netdata.service has begun execution
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
```

🌞 Configurer Netdata pour qu'il vous envoie des alertes

```c
[it5@web netdata]$ sudo cat /etc/netdata/health_alarm_notify.conf 
###############################################################################
# sending discord notifications

# note: multiple recipients can be given like this:
#                  "CHANNEL1 CHANNEL2 ..."

# enable/disable sending discord notifications
SEND_DISCORD="YES"

# Create a webhook by following the official documentation -
# https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1065194940486926376/1qS6MY4-RWJlT6UW_0j2XO_d0SCacO29HGgGJGErnBF8jIijFinzvDTjbcD4yVM4YUYW"

# if a role's recipients are not configured, a notification will be send to
# this discord channel (empty = do not send a notification for unconfigured
# roles):
DEFAULT_RECIPIENT_DISCORD="alert"
```

🌞 Vérifier que les alertes fonctionnent

```c
[it5@web netdata]$ sudo cat health.d/cpu.conf | head -n 10

# you can disable an alarm notification by setting the 'to' line to: silent

 template: 10min_cpu_usage
       on: system.cpu
    class: Utilization
     type: System
component: CPU
       os: linux
    hosts: *
[it5@web netdata]$ sudo cat health.d/cpu_usage.conf 
alarm: cpu_usage
on: system.cpu
lookup : average -3s percentage foreach user,system
units: %
every: 10s
warn: $this > 50
crit: $this > 80
[it5@web netdata]$ sudo stress --cpu 8 --io 4 --vm 2 --vm-bytes 128M --timeout 10s
```