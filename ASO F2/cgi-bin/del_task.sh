#!/bin/bash

minute=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $2}')
hour=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $4}')
day_of_month=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $6}')
month=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $8}')
day_of_week=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $10}')
taskpath=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $12}')

#We replace the %2F with / in the taskpath (the %2F is the encoding for /)
taskpath=$(echo "$taskpath" | sed 's/%2F/\//g')

fcrontab_line="$minute $hour $day_of_month $month $day_of_week $taskpath"


echo -e "Content-type: text/html"

echo -e "
<!doctype html>
<html>
<head>
    <link rel="stylesheet" href="../css/styles.css">
    <form action="../cgi-bin/mng_tasks.sh" method="get">
        <button type="submit">Go back</button>
    </form>
</head>

<body>

<p>The task with the following parameters has been deleted: $minute $hour $day_of_month $month $day_of_week $taskpath</p>

"

#We use sed to delete the line that matches the format from the fcrontab file
sudo fcrontab -l | sed "/$fcrontab_line/d" | sudo fcrontab -

echo "

</body>
</html>
"