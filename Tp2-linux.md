# TP2 : Appréhender l'environnement Linux

## I. Service SSH

### 1. Analyse du service


🌞 S'assurer que le service sshd est démarré
```c
[it5@tp2 ~]$ systemctl status | grep sshd
           │ ├─sshd.service
           │ │ └─709 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
               │ ├─1236 "sshd: it5 [priv]"
               │ ├─1240 "sshd: it5@pts/0"
               │ └─1262 grep --color=auto sshd

```

🌞 Analyser les processus liés au service SSH

```c
[it5@tp2 ~]$ ps -ef | grep sshd
root         709       1  0 11:02 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        1236     709  0 11:03 ?        00:00:00 sshd: it5 [priv]
it5         1240    1236  0 11:03 ?        00:00:00 sshd: it5@pts/0
it5         1267    1241  0 11:08 pts/0    00:00:00 grep --color=auto sshd

```

🌞 Déterminer le port sur lequel écoute le service SSH

```c
[it5@tp2 ~]$ sudo ss -ltunp | grep ssh
tcp   LISTEN 0      128          0.0.0.0:22        0.0.0.0:*    users:(("sshd",pid=709,fd=3))
tcp   LISTEN 0      128             [::]:22           [::]:*    users:(("sshd",pid=709,fd=4))

```

le prog ssh ecoute sur le port 22

🌞 Consulter les logs du service SSH

```c
[it5@tp2 ~]$ journalctl -xe -u sshd | tail -n 10 (par souci de lisibilité pour pas avoir 20 ligne)
Dec 05 11:02:36 localhost systemd[1]: Started OpenSSH server daemon.
░░ Subject: A start job for unit sshd.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit sshd.service has finished successfully.
░░
░░ The job identifier is 244.
Dec 05 11:03:35 localhost.localdomain sshd[1236]: Accepted password for it5 from 192.168.56.108 port 51711 ssh2
Dec 05 11:03:35 localhost.localdomain sshd[1236]: pam_unix(sshd:session): session opened for user it5(uid=1000) by (uid=0)




[it5@tp2 log]$ sudo cat secure | tail -n 10
Dec  5 11:16:30 localhost sudo[1297]: pam_unix(sudo:session): session opened for user root(uid=0) by it5(uid=1000)
Dec  5 11:16:30 localhost sudo[1297]: pam_unix(sudo:session): session closed for user root
Dec  5 11:21:17 localhost sudo[1310]:     it5 : TTY=pts/0 ; PWD=/home/it5 ; USER=root ; COMMAND=/bin/cd /var/log/sssd/
Dec  5 11:21:17 localhost sudo[1310]: pam_unix(sudo:session): session opened for user root(uid=0) by it5(uid=1000)
Dec  5 11:21:17 localhost sudo[1310]: pam_unix(sudo:session): session closed for user root
Dec  5 11:21:49 localhost su[1316]: pam_unix(su-l:session): session opened for user root(uid=0) by it5(uid=1000)
Dec  5 11:27:27 localhost su[1316]: pam_unix(su-l:session): session closed for user root
Dec  5 11:31:13 localhost sudo[1372]:     it5 : TTY=pts/0 ; PWD=/var/log ; USER=root ; COMMAND=/bin/cat secure
Dec  5 11:31:13 localhost sudo[1372]: pam_unix(sudo:session): session opened for user root(uid=0) by it5(uid=1000)
Dec  5 11:31:13 localhost sudo[1372]: pam_unix(sudo:session): session closed for user root
```
### 2. Modification du service

🌞 Identifier le fichier de configuration du serveur SSH

```c
[it5@tp2 /]$ cd /etc/ssh
[it5@tp2 ssh]$ ls
moduli      ssh_config.d        ssh_host_ecdsa_key.pub  ssh_host_ed25519_key.pub  ssh_host_rsa_key.pub  sshd_config.d
ssh_config  ssh_host_ecdsa_key  ssh_host_ed25519_key    ssh_host_rsa_key          sshd_config

```
le fichier de config est sshd_config car c'est le nom du processus que l'on etudie depuis le debut du tp .

```c
[it5@tp2 ssh]$ echo $RANDOM
4871

[it5@tp2 ssh]$ sudo cat ssh_config | grep Port
   Port 4871

```

```c
[it5@tp2 firewalld]$ sudo firewall-cmd --zone=public --permanent --remove-port 22/tcp
Warning: NOT_ENABLED: 22:tcp
success
[it5@tp2 firewalld]$ sudo firewall-cmd --zone=public --permanent --add-port 4871/tcp
success
[it5@tp2 firewalld]$ sudo firewall-cmd --reload
success
[it5@tp2 firewalld]$ sudo firewall-cmd --list-all | grep port
  ports: 4871/tcp
  forward-ports:
  source-ports:

[it5@tp2 firewalld]$ sudo systemctl restart sshd
```


```c
$ ssh -p 4871 it5@192.168.56.122

```

## II. Service HTTP

### 1. Mise en place

🌞 Installer le serveur NGINX
```c
[it5@tp2 ~]$ sudo dnf install nginx
```

🌞 Démarrer le service NGINX

```c
[it5@tp2 ~]$ sudo systemctl enable nginx
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service.
[it5@tp2 ~]$ sudo systemctl start nginx
```

🌞 Déterminer sur quel port tourne NGINX

```c
[it5@tp2 ~]$ sudo ss -ltunp | grep nginx
tcp   LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=1546,fd=6),("nginx",pid=1545,fd=6))
tcp   LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=1546,fd=7),("nginx",pid=1545,fd=7))

[it5@tp2 ~]$ sudo firewall-cmd --zone=public --permanent --add-port 80/tcp
success
[it5@tp2 ~]$ sudo firewall-cmd --reload
success
```
nginx ecoute sur le port 80

🌞 Déterminer les processus liés à l'exécution de NGINX

```c
[it5@tp2 ~]$ ps -ef | grep nginx
root        1545       1  0 12:36 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       1546    1545  0 12:36 ?        00:00:00 nginx: worker process
it5         1597    1326  0 12:46 pts/0    00:00:00 grep --color=auto nginx
```

🌞 Euh wait

http://192.168.56.122:80 c'est le petit site de nginx

```c
$ curl http://192.168.56.122:80 | head -n 7
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0  4349k      0 --:--:-- --:--:-- --:--:-- 7441k
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
```

### 2. Analyser la conf de NGINX

🌞 Déterminer le path du fichier de configuration de NGINX

```c
[it5@Tplinux2 ~]$ ls -al /etc/nginx/nginx.conf
-rw-r--r--. 1 root root 2334 Oct 31 16:37 /etc/nginx/nginx.conf
```

🌞 Trouver dans le fichier de conf

```c
[it5@Tplinux2 nginx]$ cat nginx.conf | grep -A 13 server
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/'*'.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }


    [it5@Tplinux2 nginx]$ cat nginx.conf | grep include -A 1
include /usr/share/nginx/modules/*.conf;
```

### 3. Déployer un nouveau site web

🌞 Créer un site web

```c
[it5@Tplinux2 nginx]$ sudo mkdir /var/www
[it5@Tplinux2 www]$ sudo mkdir tp2_linux
[it5@Tplinux2 tp2_linux]$ cat index.html
<!DOCTYPE html>
<html>
    <head>
        <h1>MEOW mon premier serveur web</h1>
    </head>
    <body>

    </body>
</html>
```
🌞 Adapter la conf NGINX

```c
[it5@Tplinux2 nginx]$ sudo systemctl restart nginx
[it5@Tplinux2 nginx]$ echo $RANDOM
8847
[it5@Tplinux2 var]$ sudo chmod 0755 /var/www
[it5@Tplinux2 nginx]$ sudo nano sites-available/tp2_linux.conf

server {
  listen       8847;
  root /var/www/tp2_linux;
}
[it5@Tplinux2 nginx]$ sudo firewall-cmd --zone=public --permanent --add-port 8847/tcp
success
[it5@Tplinux2 nginx]$ sudo firewall-cmd --reload
success

```


## III. Your own services

### 2. Analyse des services existants

```c
[it5@Tplinux2 /]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2022-12-05 12:29:57 CET; 1h 40min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 1318 (sshd)
      Tasks: 1 (limit: 4638)
     Memory: 6.5M
        CPU: 136ms
     CGroup: /system.slice/sshd.service
             └─1318 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Dec 05 12:29:57 tp2 systemd[1]: Starting OpenSSH server daemon...
Dec 05 12:29:57 tp2 sshd[1318]: Server listening on 0.0.0.0 port 4871.
Dec 05 12:29:57 tp2 sshd[1318]: Server listening on :: port 4871.
Dec 05 12:29:57 tp2 systemd[1]: Started OpenSSH server daemon.
Dec 05 12:30:31 tp2 sshd[1321]: Accepted password for it5 from 192.168.56.108 port 53111 ssh2
Dec 05 12:30:31 tp2 sshd[1321]: pam_unix(sshd:session): session opened for user it5(uid=1000) by (uid=0)
Dec 05 13:02:44 Tplinux2 sshd[1649]: Accepted password for it5 from 192.168.56.108 port 57508 ssh2
Dec 05 13:02:44 Tplinux2 sshd[1649]: pam_unix(sshd:session): session opened for user it5(uid=1000) by (uid=0)

[it5@Tplinux2 /]$ cat usr/lib/systemd/system/sshd.service | grep ExecStart
ExecStart=/usr/sbin/sshd -D $OPTIONS

[it5@Tplinux2 /]$ sudo systemctl start sshd
[it5@Tplinux2 /]$ ExecStart=/usr/sbin/sshd
```

🌞 Afficher le fichier de service NGINX

```c
[it5@Tplinux2 /]$ cat /usr/lib/systemd/system/nginx.service | grep ExecStart=
ExecStart=/usr/sbin/nginx
```

### 3. Création de service

🌞 Créez le fichier /etc/systemd/system/tp2_nc.service

```c
[it5@Tplinux2 /]$ sudo nano /etc/systemd/system/tp2_nc.service

[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=usr/bin/nc -l 8847
```

🌞 Indiquer au système qu'on a modifié les fichiers de service

```c
[it5@Tplinux2 /]$ sudo systemctl daemon-reload
```

🌞 Démarrer notre service de ouf

```c
[it5@Tplinux2 /]$ sudo systemctl start tp2_nc
```

🌞 Vérifier que ça fonctionne

```c
[it5@Tplinux2 /]$ systemctl status tp2_nc
● tp2_nc.service - Super netcat tout fou
     Loaded: loaded (/etc/systemd/system/tp2_nc.service; static)
     Active: active (running) since Mon 2022-12-05 14:33:19 CET; 2min 6s ago
   Main PID: 9348 (nc)
      Tasks: 1 (limit: 4638)
     Memory: 780.0K
        CPU: 2ms
     CGroup: /system.slice/tp2_nc.service
             └─9348 /usr/bin/nc -l 8847

Dec 05 14:33:19 Tplinux2 systemd[1]: Started Super netcat tout fou.

[it5@Tplinux2 /]$ sudo ss -ltunp | grep nc
tcp   LISTEN 0      10           0.0.0.0:8847      0.0.0.0:*    users:(("nc",pid=9348,fd=4))
tcp   LISTEN 0      10              [::]:8847         [::]:*    users:(("nc",pid=9348,fd=3))

```

🌞 Les logs de votre service

```c
[it5@Tplinux2 /]$ sudo journalctl -xe -u tp2_nc -f |grep start
Dec 05 14:31:29 Tplinux2 systemd[1]: tp2_nc.service: Unit configuration has fatal error, unit will not be started.
░░ Subject: A start job for unit tp2_nc.service has finished successfully
░░ A start job for unit tp2_nc.service has finished successfully.

[it5@Tplinux2 /]$ sudo journalctl -xe -u tp2_nc -f | grep lol
Dec 05 14:43:57 Tplinux2 nc[9348]: lol

[it5@Tplinux2 /]$ sudo journalctl -xe -u tp2_nc -f | grep Deacti
Dec 05 14:44:37 Tplinux2 systemd[1]: tp2_nc.service: Deactivated successfully.
```

🌞 Affiner la définition du service

```c
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 8847
Restart=always


[it5@Tplinux2 /]$ nc 192.168.56.122 8847
lol
^C
[it5@Tplinux2 /]$ sudo systemctl status tp2_nc
● tp2_nc.service - Super netcat tout fou
     Loaded: loaded (/etc/systemd/system/tp2_nc.service; static)
     Active: active (running) since Mon 2022-12-05 14:55:37 CET; 2s ago
   Main PID: 9497 (nc)
      Tasks: 1 (limit: 4638)
     Memory: 784.0K
        CPU: 2ms
     CGroup: /system.slice/tp2_nc.service
             └─9497 /usr/bin/nc -l 8847

Dec 05 14:55:37 Tplinux2 systemd[1]: Started Super netcat tout fou.

```