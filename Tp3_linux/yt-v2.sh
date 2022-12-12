#!/bin/bash
#id card of this computeur
while true
do
 sleep 10
 if [[ -d "/srv/yt/downloads/" && -d "/var/log/yt" ]]; then
        cd /
 else
        echo "can't download file do not exist"
        exit
 fi

 filetoread="/home/it5/downloadytvideo.txt"
 storage="/srv/yt/storage.tmp"
 while read -r line  ; do

  echo "${compteur}"
  Errors="$({ youtube-dl -q -s ${line} > /dev/null; } 2>&1)"
  if [[ -z "$Errors" ]]
  then

        youtube-dl "$line" -q -o "/srv/yt/downloads/%(title)s/%(title)s.mp4"
        title=$(youtube-dl -e "$line")
        youtube-dl "$line" -q --get-description >> "/srv/yt/downloads/${title}/description.txt"

        date=$(date +%D_%T | tr "_" " ")
        log=$(echo "[${date}] Video $1 was downloaded. File path : /srv/yt/downloads/${title}/${title}.mp4">>"/var/lo>


        echo "Video $line was downloaded"
        echo "File path : /srv/yt/downloads/${title}/${title}.mp4"
        tail -n +2 "$filetoread" > "$storage" && mv "$storage" "$filetoread"
  else
        tail -n +2 "$filetoread" > "$storage" && mv "$storage" "$filetoread"
        Errors=''
        echo "if you want to download a video go to /home/it5/downloadvideo.txt and put URL like this=https://www.you>
  fi
 done <$filetoread

 cd /srv/yt
done
