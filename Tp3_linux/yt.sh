#!/bin/bash
#id card of this computeur

if [[ -d "/srv/yt/downloads/" && -d "var/log/yt" ]]; then
        cd /
else
        echo "can't download file do not exist"
        exit
fi

youtube-dl $1 -q -o "/srv/yt/downloads/%(title)s/%(title)s.mp4"
title=$(youtube-dl -e $1)
youtube-dl $1 -q --get-description >> "/srv/yt/downloads/${title}/description.txt"

date=$(date +%D_%T | tr "_" " ")
log=$(echo "[${date}] Video $1 was downloaded. File path : /srv/yt/downloads/${title}/${title}.mp4">>"/var/log/yt/download.log")


echo "Video $1 was downloaded"
echo "File path : /srv/yt/downloads/${title}/${title}.mp4"
cd /srv/yt

