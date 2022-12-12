

echo "Machine name : $(hostnamectl | grep Static | cut -d':' -f2)"

source /etc/os-release
echo "OS ${NAME} and kernel version is $(uname -sr)"

echo "IP : $(ip a | grep 'inet ' | tail -n 1 | cut -d' ' -f6)"

echo "RAM : $(ree -h | grep Mem | tr -s " " |  cut -d' ' -f2) memory available on $(free -h | grep Mem | tr -s " " |  cut -d' ' -f7) >


echo "Disk : $(df -h | grep rl-root | tr -s " " | cut -d' ' -f2
) space left"

echo "Top 5 processes by RAM usage :  "
for i in $(seq 1 5)
do
  echo "        - $(ps -eo pmem=,cmd= --sort=-%mem | sed -n ${i}p)"
done

echo "listening ports : "

a="$(ss -pnlutH | tr -s " ")"

while read line
do
    port=$(echo "$line" | cut -d' ' -f5 | rev | cut -d':' -f1 | rev)
    type=$(echo "$line" | cut -d' ' -f1)
    name=$(echo "$line" | cut -d'"' -f2)
    echo "       - ${port} ${type} : ${name}"
done <<< "$a"



curl --silent -o chat.jpg https://cataas.com/cat

echo " "
echo "Here is your random cat : ./$(ls chat.jpg)"
