#!/bin/bash

# 0. Удаление всех файлов из /tmp/result/
rm -rf /tmp/result/*
mkdir -p /tmp/result

# 1. Создание папок
mkdir -p ~/resources/{disk,process,memory,user}

# 2. Создание файлов
touch ~/resources/{d.txt,p.txt,m.txt,u.txt}

# 3. Запись информации о свободном месте на дисках в d.txt
df -h > ~/resources/d.txt

# 4. Запись информации о 10 самых ресурсоёмких процессах в p.txt
ps -eo pid,user,%mem,%cpu,command --sort=-%mem | head -n 11 > ~/resources/p.txt

# 5. Запись информации об оперативной памяти в m.txt
free -h > ~/resources/m.txt

# 6. Запись информации о пользователе в u.txt
{
    echo "Информация из /etc/passwd:"
    grep "^$(whoami):" /etc/passwd
    echo -e "\nВремя последнего логина:"
    lastlog -u $(whoami)
    echo -e "\nГруппы пользователя:"
    groups $(whoami)
    echo -e "\nСодержимое домашней директории:"
    ls -la ~
} > ~/resources/u.txt
# 7. Перемещение файлов и изменение их имён
mv ~/resources/d.txt ~/resources/disk/disk.txt
mv ~/resources/p.txt ~/resources/process/process.txt
mv ~/resources/m.txt ~/resources/memory/memory.txt
cp ~/resources/u.txt ~/resources/user/user.txt

# 8. Смена группы и прав для папок и файлов
sudo chgrp -R resgrp ~/resources/{disk,process,memory,user}
sudo chmod -R 770 ~/resources/{disk,process,memory,user}

# 9. Создание архива с текущей датой и временем
timestamp=$(date +"%Y%m%d_%H%M%S")
tar -czf /tmp/result/resources_$timestamp.tar.gz -C ~/ resources

echo "Скрипт выполнен успешно. Архив создан в /tmp/result/"



