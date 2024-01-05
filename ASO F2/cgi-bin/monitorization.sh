#!/bin/bash

echo -e "Content-type: text/html"

cpu_usage=$(top -bn1 | grep "Cpu" | awk -F'[:/]' '{print $2}')
total_tasks=$(top -bn1 | grep "Tasks:" | awk '{print $2}')
running_tasks=$(top -bn1 | grep "Tasks:" | awk '{print $4}')
sleeping_tasks=$(top -bn1 | grep "Tasks:" | awk '{print $6}')
stopped_tasks=$(top -bn1 | grep "Tasks:" | awk '{print $8}')
zombie_tasks=$(top -bn1 | grep "Tasks:" | awk '{print $10}')

total_ram_memory=$(free -h | grep "Mem:" | awk '{print $2}')
used_ram_memory=$(free -h | grep "Mem:" | awk '{print $3}')

total_disk_memory=$(df -h | grep "/dev/root" | awk '{print $2}')
used_disk_memory=$(df -h | grep "/dev/root" | awk '{print $3}')

ten_last_accesses_info=$(tail -n 10 /var/log/httpd/access.log)

echo -e "
<!doctype html>
<html>
<head>
    <link rel="stylesheet" href="../css/styles.css">
    <form action="../html/home.html" method="get">
        <button type="submit">Home</button>
    </form>
</head>

<body>

    <h1>Monitorization</h1>

    <p><b>CPU</b></p>

    <p>CPU usage: $cpu_usage% </p>

    <p>Total Tasks: $total_tasks, Running Tasks: $running_tasks, Sleeping Tasks: $sleeping_tasks, Stopped Tasks: $stopped_tasks, Zombie Tasks: $zombie_tasks</p>
    
    <br>

    <p><b>RAM memory</b></p>

    <p>Total Memory: $total_ram_memory</p>
    <p>Used Memory: $used_ram_memory</p>

    <br>

    <p><b>Disk memory</b></p>

    <p>Total Memory: $total_disk_memory</p>
    <p>Used Memory: $used_disk_memory</p>

    <br>

    <p><b>10 Last Accesses to Server</b></p>
"

while IFS= read -r line; do
    date_string=$(echo "$line" | awk -F'[][]' '{print $2}')
    echo -e "<p>$date_string</p>"
done <<< "$ten_last_accesses_info"


time_up=$(uptime | awk '{print $3}')
hours_up=$(echo $time_up | awk -F'[:,]' '{print $1}')
minutes_up=$(echo $time_up | awk -F'[:,]' '{print $2}')


echo -e "
        <br>
        <p><b>Server uptime</b></p>
        <p>$hours_up hours, $minutes_up minutes running</p>
"

echo "
</body>
</html>
"