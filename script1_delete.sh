#!/bin/bash

# 0. Remove all files from /tmp/result/
rm -rf /tmp/result/*
mkdir -p /tmp/result

# 1. Create directories
mkdir -p ~/resources/{disk,process,memory,user}

# 2. Create files
touch ~/resources/{d.txt,p.txt,m.txt,u.txt}

# 3. Record information about available disk space in d.txt
df -h > ~/resources/d.txt

# 4. Record information about the top 10 resource-intensive processes in p.txt
ps -eo pid,user,%mem,%cpu,command --sort=-%mem | head -n 11 > ~/resources/p.txt

# 5. Record information about memory usage in m.txt
free -h > ~/resources/m.txt

# 6. Record user information in u.txt
{
    echo "Information from /etc/passwd:"
    grep "^$(whoami):" /etc/passwd
    echo -e "\nLast login time:"
    lastlog -u $(whoami)
    echo -e "\nUser groups:"
    groups $(whoami)
    echo -e "\nContents of the home directory:"
    ls -la ~
} > ~/resources/u.txt

# 7. Move and rename files
mv ~/resources/d.txt ~/resources/disk/disk.txt
mv ~/resources/p.txt ~/resources/process/process.txt
mv ~/resources/m.txt ~/resources/memory/memory.txt
cp ~/resources/u.txt ~/resources/user/user.txt

# 8. Change group and permissions for directories and files
sudo chgrp -R resgrp ~/resources/{disk,process,memory,user}
sudo chmod -R 770 ~/resources/{disk,process,memory,user}

# 9. Create an archive with the current date and time
timestamp=$(date +"%Y%m%d_%H%M%S")
tar -czf /tmp/result/resources_$timestamp.tar.gz -C ~/ resources

echo "Script executed successfully. Archive created in /tmp/result/"
