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