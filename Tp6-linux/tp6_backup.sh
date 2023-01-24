#!/bin/bash
# scirpt de back up du serveur nginx vers /srv/backup
#ecrit le  230116
#writting by Lorens

name="nextcloud$(date +%s)"


zip -r /srv/backup/"$name".zip  /var/www/tp5_nextcloud/config/ /var/www/tp5_nextcloud/data/ /var/www/tp5_nextcloud/themes/


echo "$name"
