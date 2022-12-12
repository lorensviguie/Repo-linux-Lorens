# TP 3 : We do a little scripting

# TP 3 : We do a little scripting

## I.. Script carte d'identité

[📁 Fichier /srv/idcard/idcard.sh](/Tp3_linux/idcard.sh)

🌞 Vous fournirez dans le compte-rendu, en plus du fichier, un exemple d'exécution avec une sortie, dans des balises de code.

```c

[it5@it5 idcard]$ sudo ./idcard.sh
Machine name :  it5
OS Rocky Linux and kernel version is Linux 5.14.0-162.6.1.el9_1.x86_64
IP : 192.168.56.124/24
./idcard.sh: line 11: ree: command not found
RAM :  memory available on 501Mi total memory
Disk : 9.8G space left
Top 5 processes by RAM usage :
        -  5.3 /usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
        -  2.6 /usr/sbin/NetworkManager --no-daemon
        -  1.9 /usr/lib/systemd/systemd --switched-root --system --deserialize 30
        -  1.6 /usr/lib/systemd/systemd --user
        -  1.5 sshd: it5 [priv]
listening ports :
        - 323 udp : chronyd
        - 323 udp : chronyd
        - 22 tcp : sshd
        - 22 tcp : sshd

Here is your random cat : ./chat.jpg

```

## II. Script youtube-dl

[📁 Le script /srv/yt/yt.sh](/Tp3_linux/yt.sh)

[📁 Le fichier de log /var/log/yt/download.log](/Tp3_linux/download.log)

```c
[it5@it5 yt]$ ./yt.sh https://www.youtube.com/watch?v=jhFDyDgMVUI
Video https://www.youtube.com/watch?v=jhFDyDgMVUI was downloaded
File path : /srv/yt/downloads/One Second Video/One Second Video.mp4
```


## III. MAKE IT A SERVICE

[📁 Le script /srv/yt/yt-v2.sh](/Tp3_linux/yt-v2.sh)

[📁 Fichier /etc/systemd/system/yt.service](/Tp3_linux/yt.service)

🌞 Vous fournirez dans le compte-rendu, en plus des fichiers :

       - un systemctl status yt quand le service est en cours de fonctionnement
```c
[it5@it5 system]# systemctl status yt
● yt.service - Telechargé des videos youtube
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; vendor preset: disabled)
     Active: active (running) since Mon 2022-12-12 16:59:27 CET; 3min 21s ago
   Main PID: 10013 (bash)
      Tasks: 1 (limit: 4638)
     Memory: 424.0K
        CPU: 2min 56.749s
     CGroup: /system.slice/yt.service
             └─10013 /bin/bash /srv/yt/yt-v2.sh

Dec 12 16:59:36 it5 bash[10013]: File path : /srv/yt/downloads/1 second video/1 second video.mp4
Dec 12 16:59:37 it5 bash[10013]: if you want to download a video go to /home/it5/downloadvideo.txt and put URL like this=https://www.youtube.com/watch?v=jhFDyDgMVUI in the file
```
       - un extrait de journalctl -xe -u yt
```c
[it5@it5 system]# journalctl -xe -u yt
Dec 12 16:59:46 it5 bash[10013]: Video https://www.youtube.com/watch?v=ueJwZt3nmaQ was downloaded
Dec 12 16:59:46 it5 bash[10013]: File path : /srv/yt/downloads/Une vidéo de 1 seconde avec un fond noir/Une vidéo de 1 seconde avec un fond noir.mp4
Dec 12 16:59:48 it5 bash[10013]: if you want to download a video go to /home/it5/downloadvideo.txt and put URL like this=https://www.youtube.com/watch?v=jhFDyDgMVUI in the file
Dec 12 16:59:49 it5 bash[10013]: if you want to download a video go to /home/it5/downloadvideo.txt and put URL like this=https://www.youtube.com/watch?v=jhFDyDgMVUI in the file
Dec 12 16:59:51 it5 bash[10013]: if you want to download a video go to /home/it5/downloadvideo.txt and put URL like this=https://www.youtube.com/watch?v=jhFDyDgMVUI in the file
Dec 12 16:59:59 it5 bash[10013]: Video https://www.youtube.com/watch?v=kvO_nHnvPtQ was downloaded
Dec 12 16:59:59 it5 bash[10013]: File path : /srv/yt/downloads/1 second black screen video/1 second black screen video.mp4

```