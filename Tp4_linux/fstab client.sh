
#
# /etc/fstab
# Created by anaconda on Mon Nov 28 09:47:45 2022
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rl-root     /                       xfs     defaults        0 0
UUID=1e80954b-1c35-4720-a8f0-34e7080b11b3 /boot                   xfs     defaults        0 0
/dev/mapper/rl-swap     none                    swap    defaults        0 0

192.168.56.128:/var/nfs/general /nfs/general   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
192.168.56.128:/storage /nfs/storage      nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
