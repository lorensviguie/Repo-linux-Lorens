# Detruire des vms linux 

on va essayer de casser des vms ca resume bien le cour 

## 1.premiere Methode 

demarche : le fichier .bashrc se lance dés que on se log sur la session 

``` c 
sudo nano .bashrc
on ecrit exit ligne 2

exit
```
et voila mtn dés que l'on se log on quitte 

## 2.deuxieme Methode

si on supprime le sique dur , l'ordinateur pourra plus demaré car il aura plus rien sur quoi boot .

pour cela on utilise la commande shred qui permet de supprimer definitevement le contenu d'un dossier ou fichier 
pour cela on rentre la commande shred -n 20 -z -u -v /dev/sda

```c
sudo shred -n 20 -z -u -v /dev/sda
```
-n 20 réecrit 20 fois le fichier   
-z remplace avec des zéro  
-v permet de suivre le processus dans le terminal   
-u supprime le fichier apres la réecriture   

## 3.troisieme Methode 

je vais etre honete j'ai pas tous comprit sur le dossier entries j'ai juste comprit que ca a un rapport avec le disque dur est son arborcense   

```c
su -
cd /
cd /boot/loader/entries
shred -n 10 -z -u -v b9*.conf 
```
quand on reboot il ne trouve plus son disque pour rebbot et ducoup il rebbot sur grub.

## 4.Quatrième methode 

petite Fork bomb
dans le home 
```c
sudo nano /bashrc

 :(){ :|:& };:
```
on ecrit ca au debut du programme 
et sauf si on spam le controle c au debut on peut plus rien faire dans le user ou on est log 

## 5.Cinquième methode
on va copier coller le code magique dans /etc/profile
```c
[root@localhost ~]# nano /etc/profile
```
[le code magique](/thatsabadideatolaunchit.sh)
petit fork bomb bien mechante

mtn on crée un fichier dans le system 

```c
sudo nano /etc/systemd/system/gentilpromis.service

[Unit]
After=mysql.service

[Service]
ExecStart=/usr/local/bin/je_suis_vraiment_cool_promit.sh

[Install]
WantedBy=default.target
```
ensuite on crée notre .sh avec notre script
```c
sudo nano /usr/local/bin/je_suis_vraiment_cool_promit.sh
```
on oublie pas de bien definir les permissions de notre fichier 
```c
chmod 744 /usr/local/bin/je_suis_vraiment_cool_promit.sh
chmod 664 /etc/systemd/system/gentilpromis.service
```
on peut copier coller [le deuxieme code magique](/vfoflinuxending.sh)

## 6.Sixième methode 
Le disque dur 

```c
sudo nano /etc/fstab

systemctl daemom-reload
shred -n 6 -z -u -v /dev/disk/by-partuuif/double tab avec le premier 
shred -n 6 -z -u -v /dev/disk/by-partuuif/double tab avec l'autre
```
on supprime les 3 ligne en blanc pour la premiere commande
et bah y'a plus de disk donc compliquer de faire quoi que se soit 

PS : j'ai cherché tout le week-end comment modifier directement des une petite donnée dans le disque ou sur le chemin d'accés vers le disque mais jai rien trouver de vraiment cool du coup je te laisse avec le truc de bourrin 