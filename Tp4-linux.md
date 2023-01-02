# Partie 1 : Partitionnement du serveur de stockage

🌞 Partitionner le disque à l'aide de LVM

```c
[it5@storage ~]$ sudo pvs
  Devices file sys_wwid t10.ATA_____VBOX_HARDDISK___________________________VB1e8d7d97-acc2f1fe_ PVID rLf9eqVJj2iIfOQUbcZAgjeFhSLI8CRQ last seen on /dev/sda2 not found.
  PV         VG      Fmt  Attr PSize  PFree
  /dev/sdb   storage lvm2 a--  <2.00g    0

```

🌞 Formater la partition
```c
[it5@storage ~]$ sudo mkfs -t ext4 /dev/storage/storage_linux
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 523264 4k blocks and 130816 inodes
Filesystem UUID: 1911cb08-577a-41db-a8eb-4472377193ee
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

```


🌞 Monter la partition

[📁 Le script /etc/fstab](/Tp4_linux/fstab.sh)
```c
[it5@storage /]$ sudo umount /storage/
[it5@storage /]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount: /mnt/Mstore does not contain SELinux labels.
       You just mounted a file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
/mnt/Mstore              : successfully mounted


[it5@storage /]$ df -h
/dev/mapper/storage-storage_linux  2.0G   24K  1.9G   1% /storage
```

# Partie 2 : Serveur de partage de fichiers



### ---Serveur---
```c
[it5@storage storage]$ sudo systemctl enable nfs-server
Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service.
[it5@storage storage]$ sudo systemctl start nfs-server
[it5@storage storage]$ sudo systemctl status nfs-server
● nfs-server.service - NFS server and services
     Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; enabled; vendo>
    Drop-In: /run/systemd/generator/nfs-server.service.d
             └─order-with-mounts.conf
     Active: active (exited) since Tue 2022-12-13 12:07:22 CET; 16s ago
    Process: 11689 ExecStartPre=/usr/sbin/exportfs -r (code=exited, status=0/SU>
    Process: 11690 ExecStart=/usr/sbin/rpc.nfsd (code=exited, status=0/SUCCESS)
    Process: 11707 ExecStart=/bin/sh -c if systemctl -q is-active gssproxy; the>
   Main PID: 11707 (code=exited, status=0/SUCCESS)
        CPU: 13ms


[it5@storage storage]$ cat /etc/exports
/var/nfs/general 192.168.56.126(rw,sync,no_subtree_check)
/storage 192.168.56.126(rw,sync,no_root_squash,no_subtree_check)


[it5@storage storage]$ sudo firewall-cmd --permanent --add-service=nfs
success
[it5@storage storage]$ sudo firewall-cmd --permanent --add-service=mountd
success
[it5@storage storage]$ sudo firewall-cmd --permanent --add-service=rpc-bind
success
[it5@storage storage]$ sudo firewall-cmd --reload
success
[it5@storage storage]$ sudo firewall-cmd --permanent --list-all | grep services
  services: cockpit dhcpv6-client mountd nfs rpc-bind ssh

```

### ---Client---


[📁 Le script /etc/fstab du client](/Tp4_linux/fstab%20client.sh)
```c
[it5@Webserver ~]$ df -h
192.168.56.128:/var/nfs/general  9.8G  1.3G  8.6G  13% /nfs/general
192.168.56.128:/storage          2.0G     0  1.9G   0% /nfs/storage
```

# Partie 3 : Serveur web

## 2. Install

🌞 Installez NGINX

```c
[it5@Webserver ~]$ sudo dnf install nginx
Installed:
  nginx-1:1.20.1-13.el9.x86_64             nginx-core-1:1.20.1-13.el9.x86_64
  nginx-filesystem-1:1.20.1-13.el9.noarch  rocky-logos-httpd-90.13-1.el9.noarch
```

## 3. Analyse

```c
[it5@Webserver ~]$ ps -ef | grep nginx
root        1502       1  0 13:59 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       1503    1502  0 13:59 ?        00:00:00 nginx: worker process
it5         1565    1283  0 14:02 pts/0    00:00:00 grep --color=auto nginx

[it5@Webserver ~]$ sudo ss -alptn | grep nginx
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=1503,fd=6),("nginx",pid=1502,fd=6))
LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=1503,fd=7),("nginx",pid=1502,fd=7))

[it5@localhost nginx]$ cat /etc/nginx/nginx.conf | grep usr
# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/'*'.conf;
        root         /usr/share/nginx/html;
#        root         /usr/share/nginx/html;

[it5@localhost nginx]$ ls -l
total 0
drwxr-xr-x. 3 root root 143 Dec 13 13:57 html
drwxr-xr-x. 2 root root   6 Oct 31 16:37 modules
```

## 4. Visite du service web

🌞 Configurez le firewall pour autoriser le trafic vers le service NGINX

```c
[it5@localhost nginx]$ sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
[sudo] password for it5:
success
```

🌞 Accéder au site web

```c
[it5@localhost nginx]$ curl http://192.168.56.126:80
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
... ^^
      <footer class="col-sm-12">
      <a href="https://apache.org">Apache&trade;</a> is a registered trademark of <a href="https://apache.org">the Apache Software Foundation</a> in the United States and/or other countries.<br />
      <a href="https://nginx.org">NGINX&trade;</a> is a registered trademark of <a href="https://">F5 Networks, Inc.</a>.
      </footer>

  </body>
</html>
```

🌞 Vérifier les logs d'accès

```c

```

## 5. Modif de la conf du serveur web

🌞 Changer le port d'écoute

```c
[it5@localhost /]$ sudo cat /etc/nginx/nginx.conf |grep 8080
        listen       8080;

[it5@localhost /]$ sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
     Active: active (running) since Tue 2022-12-13 14:44:28 CET; 10s ago

[it5@localhost /]$ sudo ss -alptn | grep nginx
LISTEN 0      511          0.0.0.0:8080      0.0.0.0:*    users:(("nginx",pid=1723,fd=6),("nginx",pid=1722,fd=6))

[it5@localhost /]$ curl http://192.168.56.126:8080
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>

```

🌞 Changer l'utilisateur qui lance le service

```c
[it5@localhost storage]$ sudo cat /etc/nginx/nginx.conf | grep web
user web;

web         1823    1822  0 14:57 ?        00:00:00 nginx: worker process
```

🌞 Changer l'emplacement de la racine Web

```c
[it5@localhost storage]$ sudo cat /etc/nginx/nginx.conf | tail -n 6
server {
        server_name 100.200.200.50
        listen      8080;
        root        /var/www/site_web_1;
        index       index.html;
}

```


## 6. Deux sites web sur un seul serveur

🌞 Repérez dans le fichier de conf
```c
[it5@localhost nginx]$ cat nginx.conf |grep conf.d
    # Load modular configuration files from the /etc/nginx/conf.d directory.
    include /etc/nginx/conf.d/*.conf;
```

🌞 Créez le fichier de configuration pour le premier site

```c
[it5@localhost conf.d]$ cat site_web_1.conf |head -n 5
server {
        listen 8080;

        server_name first_site.com;
        root /var/www/site_web_1;
```


🌞 Créez le fichier de configuration pour le deuxième site
```c
[it5@localhost conf.d]$ cat site_web_2.conf |head -n 5
server {
        listen 8888;

        server_name second_site.com;
        root /var/www/site_web_2;
```

🌞 Prouvez que les deux sites sont disponibles

```c
[it5@localhost /]$ curl http://192.168.56.126:8080
<!DOCTYPE html>
<html>
    <head>
        <h1>MEOW mon premier serveur web</h1>
    </head>
    <body>

    </body>
</html>

[it5@localhost /]$ curl http://192.168.56.126:8888
<!DOCTYPE html>
<html>
<head>
        <title>Ma page HTML</title>
</head>
<body>
        <h1>Titre</h1>
        <p>Voici un paragraphe de texte.</p>
</body>
</html>

```