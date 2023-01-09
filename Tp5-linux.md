# TP5 : Self-hosted cloud

# Partie 1 : Mise en place et maîtrise du serveur Web

## 1. Installation

🌞 Installer le serveur Apache
```c
[it5@web conf]$ sudo cat /etc/httpd/conf/httpd.conf |head -n 5

# This is the main Apache HTTP server configuration file.  It contains the
# configuration directives that give the server its instructions.
# See <URL:http://httpd.apache.org/docs/2.4/> for detailed information.
# In particular, see

```

🌞 Démarrer le service Apache

```c
[it5@web conf]$ sudo systemctl status httpd
● httpd.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor pr>
     Active: active (running) since Tue 2023-01-03 14:52:38 CET; 5s ago
Jan 03 14:52:38 web systemd[1]: Started The Apache HTTP Server.
Jan 03 14:52:38 web httpd[1642]: Server configured, listening on: port 80
[it5@web conf]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
```

🌞 TEST

```c
[it5@web conf]$ curl web |head -n 5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
100  7620  100  7620    0     0   826k      0 --:--:-- --:--:-- --:--:--  826k
```

## 2. Avancer vers la maîtrise du service


🌞 Le service Apache...
```c
[it5@web ~]$ sudo cat /usr/lib/systemd/system/httpd.service | tail -n 5
PrivateTmp=true
OOMPolicy=continue

[Install]
WantedBy=multi-user.target
```

🌞 Déterminer sous quel utilisateur tourne le processus Apache

```c
[it5@web ~]$ sudo cat /etc/httpd/conf/httpd.conf | grep User
User apache
[it5@web ~]$ sudo ps -ef | grep apache
apache      1600    1599  0 15:10 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      1601    1599  0 15:10 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      1602    1599  0 15:10 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      1603    1599  0 15:10 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
[it5@web testpage]$ ls -al
total 12
drwxr-xr-x.  2 root root   24 Jan  3 15:09 .
drwxr-xr-x. 81 root root 4096 Jan  3 15:09 ..
-rw-r--r--.  1 root root 7620 Jul 27 20:05 index.html
```

🌞 Changer l'utilisateur utilisé par Apache

```c
[it5@web ~]$ sudo cat /etc/httpd/conf/httpd.conf | grep User
User tplinux5

[it5@web ~]$ ps -ef | grep tplinux5
tplinux5    1990    1989  0 15:28 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
tplinux5    1991    1989  0 15:28 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
tplinux5    1992    1989  0 15:28 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
tplinux5    1993    1989  0 15:28 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
it5         2211    1953  0 15:28 pts/0    00:00:00 grep --color=auto tplinux5
```

🌞 Faites en sorte que Apache tourne sur un autre port

```c
[it5@web ~]$ sudo cat /etc/httpd/conf/httpd.conf |grep 81
Listen 81
[it5@web ~]$ sudo ss -alptn | grep 81
LISTEN 0      511                *:81              *:*    users:(("httpd",pid=2478,fd=4),("httpd",pid=2477,fd=4),("httpd",pid=2476,fd=4),("httpd",pid=2474,fd=4))
[it5@web ~]$ curl web:81 | head -n 5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
<!doctype html>    0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
100  7620  100  7620    0     0   930k      0 --:--:-- --:--:-- --:--:--  930k

```

[📁 Fichier /etc/httpd/conf/httpd.conf](./Tp5-linux/httpd.conf)

# Partie 2 : Mise en place et maîtrise du serveur de base de données

🌞 Install de MariaDB sur db.tp5.linux

```c
[it5@db ~]$ sudo dnf install mariadb-server
Last metadata expiration check: 0:41:31 ago on Tue Jan  3 15:28:08 2023.
Package mariadb-server-3:10.5.16-2.el9_0.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!
[it5@db ~]$ sudo systemctl enable mariadb
Created symlink /etc/systemd/system/mysql.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/mysqld.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/multi-user.target.wants/mariadb.service → /usr/lib/systemd/system/mariadb.service.

[it5@db ~]$ sudo mysql_secure_installation
...
Reload privilege tables now? [Y/n] Y
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!'
[it5@db ~]$ sudo systemctl is-enabled mariadb
enabled
```

🌞 Port utilisé par MariaDB
```c
[it5@db ~]$ sudo ss -alptn | grep maria
LISTEN 0      80                 *:3306            *:*    users:(("mariadbd",pid=770,fd=19))
[it5@db ~]$ sudo firewall-cmd --add-port=3306/tcp --permanent
success
[it5@db ~]$ sudo firewall-cmd --reload
success
```

🌞 Processus liés à MariaDB
```c
[it5@db ~]$ ps -ef | grep maria
mysql       1460       1  0 16:32 ?        00:00:00 /usr/libexec/mariadbd --basedir=/usr
it5         1553    1294  0 16:40 pts/0    00:00:00 grep --color=auto maria

```

# Partie 3 : Configuration et mise en place de NextCloud

## 1. Base de données

🌞 Préparation de la base pour NextCloud

```c
MariaDB [(none)]> CREATE USER 'nextcloud'@'192.168.56.131' IDENTIFIED BY 'pewpewpew';
Query OK, 0 rows affected (0.002 sec)
MariaDB [(none)]> CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
Query OK, 1 row affected (0.000 sec)
MariaDB [(none)]> GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'192.168.56.131';
Query OK, 0 rows affected (0.002 sec)
MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.000 sec)
```

🌞 Exploration de la base de données
```c
[it5@web ~]$ mysql -u nextcloud -h 192.168.56.130 -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.

mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| nextcloud          |
+--------------------+
2 rows in set (0.00 sec)
```

🌞 Trouver une commande SQL qui permet de lister tous les utilisateurs de la base de données

```c
MariaDB [(none)]> SELECT User, Host FROM mysql.user;
+-------------+----------------+
| User        | Host           |
+-------------+----------------+
| nextcloud   | 192.168.56.131 |
| mariadb.sys | web      |
| mysql       | web      |
| root        | web      |
+-------------+----------------+
4 rows in set (0.002 sec)
```

## 2. Serveur Web et NextCloud

🌞 Install de PHP

```c
[it5@web ~]$ sudo dnf config-manager --set-enabled crb
[it5@web ~]$ sudo dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-9.rpm -y
Rocky Linux 9 - BaseOS                                                                10 kB/s | 3.6 kB     00:00
Rocky Linux 9 - BaseOS                                                               2.4 MB/s | 1.7 MB     00:00
Rocky Linux 9 - AppStream                                                             15 kB/s | 4.1 kB     00:00
=====================================================================================================================
Installing:
 remi-release                noarch                9.0-6.el9.remi                  @commandline                 25 k
 yum-utils                   noarch                4.1.0-3.el9                     baseos                       36 k
Installing dependencies:
 epel-release                noarch                9-4.el9                         extras                       19 k

Transaction Summary
=====================================================================================================================
Install  3 Packages


[it5@web ~]$ sudo dnf module enable php:remi-8.1 -y
=====================================================================================================================
 Package                    Architecture              Version                       Repository                  Size
=====================================================================================================================
Enabling module streams:
 php                                                  remi-8.1

Transaction Summary
=====================================================================================================================

Complete!

```

🌞 Install de tous les modules PHP nécessaires pour NextCloud

```c
[it5@web ~]$ sudo dnf install -y libxml2 openssl php81-php php81-php-ctype php81-php-curl php81-php-gd php81-php-iconv php81-php-json php81-php-libxml php81-php-mbstring php81-php-openssl php81-php-posix php81-php-session php81-php-xml php81-php-zip php81-php-zlib php81-php-pdo php81-php-mysqlnd php81-php-intl php81-php-bcmath php81-php-gmp
Last metadata expiration check: 0:02:36 ago on Tue Jan  3 17:08:07 2023.
Package libxml2-2.9.13-2.el9.x86_64 is already installed.
Package openssl-1:3.0.1-43.el9_0.x86_64 is already installed.
Dependencies resolved.
=====================================================================================================================
 Package                                 Architecture      Version                        Repository            Size
=====================================================================================================================
Installing:
  python3-setools-4.4.0-5.el9.x86_64                         python3-setuptools-53.0.0-10.el9.noarch
  rav1e-libs-0.5.1-5.el9.x86_64                              remi-libzip-1.9.2-3.el9.remi.x86_64
  scl-utils-1:2.0.3-2.el9.x86_64                             shared-mime-info-2.1-4.el9.x86_64
  svt-av1-libs-0.9.0-1.el9.x86_64                            tcl-1:8.6.10-7.el9.x86_64
  xml-common-0.6.3-58.el9.noarch

Complete!
```

🌞 Récupérer NextCloud

```c
[it5@web tp5_nextcloud]$ wget https://download.nextcloud.com/server/prereleases/nextcloud-25.0.0rc3.zip
[it5@web tp5_nextcloud]$ unzip nextcloud-25.0.0rc3.zip
[it5@web ~]$ ls
nextcloud  nextcloud-25.0.0rc3.zip  unzip
[it5@web tp5_nextcloud]$ sudo mv nextcloud/".*" /var/www/tp5_nextcloud/                               

[it5@web tp5_nextcloud]$ ls -al
total 140
drwxr-xr-x  15 apache root  4096 Jan  3 17:38 .
drwxr-xr-x.  5 root   root    54 Jan  3 17:14 ..
-rw-r--r--   1 apache it5   3253 Oct  6 14:42 .htaccess
-rw-r--r--   1 apache it5    101 Oct  6 14:42 .user.ini
drwxr-xr-x  47 apache it5   4096 Oct  6 14:47 3rdparty
-rw-r--r--   1 apache it5  19327 Oct  6 14:42 AUTHORS
-rw-r--r--   1 apache it5  34520 Oct  6 14:42 COPYING
drwxr-xr-x  50 apache it5   4096 Oct  6 14:44 apps
drwxr-xr-x   2 apache it5     67 Oct  6 14:47 config
-rw-r--r--   1 apache it5   4095 Oct  6 14:42 console.php
drwxr-xr-x  23 apache it5   4096 Oct  6 14:47 core
-rw-r--r--   1 apache it5   6317 Oct  6 14:42 cron.php
drwxr-xr-x   2 apache it5   8192 Oct  6 14:42 dist
-rw-r--r--   1 apache it5    156 Oct  6 14:42 index.html
-rw-r--r--   1 apache it5   3456 Oct  6 14:42 index.php
drwxr-xr-x   6 apache it5    125 Oct  6 14:42 lib
drwxr-xr-x   2 apache it5      6 Jan  3 17:38 nextcloud
-rw-r--r--   1 apache it5    283 Oct  6 14:42 occ
drwxr-xr-x   2 apache it5     23 Oct  6 14:42 ocm-provider
drwxr-xr-x   2 apache it5     55 Oct  6 14:42 ocs
drwxr-xr-x   2 apache it5     23 Oct  6 14:42 ocs-provider
-rw-r--r--   1 apache it5   3139 Oct  6 14:42 public.php
-rw-r--r--   1 apache it5   5426 Oct  6 14:42 remote.php
drwxr-xr-x   4 apache it5    133 Oct  6 14:42 resources
-rw-r--r--   1 apache it5     26 Oct  6 14:42 robots.txt
-rw-r--r--   1 apache it5   2452 Oct  6 14:42 status.php
-rw-r--r--   1 apache root     0 Jan  3 17:18 test
drwxr-xr-x   3 apache it5     35 Oct  6 14:42 themes
drwxr-xr-x   2 apache it5     43 Oct  6 14:44 updater
-rw-r--r--   1 apache it5    387 Oct  6 14:47 version.php
```

🌞 Adapter la configuration d'Apache

```c
[it5@web ~]$ sudo cat /etc/httpd/conf.d/useit.conf
<VirtualHost *:80>
  # on indique le chemin de notre webroot
  DocumentRoot /var/www/tp5_nextcloud/
  # on précise le nom que saisissent les clients pour accéder au service
  ServerName  web.tp5.linux
```

## 3. Finaliser l'installation de NextCloud

```c

[it5@db ~]$ sudo cat /etc/hosts | tail -n 1
192.168.56.131 web.tp5.linux


```

### 3. Finaliser l'installation de NextCloud

🌞 Exploration de la base de données

```c

```