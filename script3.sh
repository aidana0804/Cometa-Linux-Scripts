#!/bin/bash

# Get the current date and time for the report
current_time=$(date "+%Y-%m-%d %H:%M:%S")
# Generate a unique filename based on the current date and time
filename=$(date "+system_report_%Y%m%d_%H%M%S.txt")

# Retrieve the current CPU usage by calculating the percentage of CPU being used (100% - idle percentage)
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')

# Gather memory usage details (total, used, free) in megabytes (MB)
mem_info=$(free -m)
total_memory=$(echo "$mem_info" | grep "Mem:" | awk '{print $2}')
used_memory=$(echo "$mem_info" | grep "Mem:" | awk '{print $3}')
free_memory=$(echo "$mem_info" | grep "Mem:" | awk '{print $4}')

# Collect disk usage information for the root filesystem (total, used, free space)
disk_info=$(df -h / | tail -1)
total_disk=$(echo "$disk_info" | awk '{print $2}')
used_disk=$(echo "$disk_info" | awk '{print $3}')
free_disk=$(echo "$disk_info" | awk '{print $4}')

# List the top 5 processes consuming the most CPU, along with their process ID and command
top_cpu_processes=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6)
# List the top 5 processes consuming the most RAM, along with their process ID and command
top_ram_processes=$(ps -eo pid,comm,%mem --sort=-%mem | head -n 6)

# Construct the system report with the collected data
report=$(cat <<EOF
System Report - $current_time
-------------------------
CPU Usage:
- Current CPU usage: $cpu_usage

Memory Usage:
- Total Memory: ${total_memory} MB
- Used Memory: ${used_memory} MB
- Free Memory: ${free_memory} MB

Disk Usage:
- Total Disk Space: $total_disk
- Used Disk Space: $used_disk
- Free Disk Space: $free_disk

Top 5 Processes by CPU Usage:
$top_cpu_processes

Top 5 Processes by RAM Usage:
$top_ram_processes
EOF
)

# Save the report to a file with the generated filename
echo "$report" > "$filename"
# Output a message indicating where the report was saved
echo "Report saved as $filename"
