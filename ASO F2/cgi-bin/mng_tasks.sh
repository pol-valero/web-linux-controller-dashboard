#!/bin/bash

minute=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $2}')
hour=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $4}')
day_of_month=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $6}')
month=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $8}')
day_of_week=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $10}')
taskpath=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $12}')

arguments="$minute$hour$day_of_month$month$day_of_week$taskpath"

#We replace the %2F with / in the taskpath (the %2F is the encoding for /)
taskpath=$(echo "$taskpath" | sed 's/%2F/\//g')

fcrontab_table=$(sudo fcrontab -l)


echo -e "Content-type: text/html"

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
    <h1>Manage preprogrammed tasks</h1>

    <form action='../cgi-bin/mng_tasks.sh' method='get'>
        <p>Minute (0-59):</p>
        <input id='minute' name='minute' required>
        <p>Hour (0-23):</p>
        <input id='hour' name='hour' required>
        <p>Day of month (0-31):</p>
        <input id='day_of_month' name='day_of_month' required>
        <p>Month (1-12):</p>
        <input id='month' name='month' required>
        <p>Day of week (0-7):</p>
        <input id='day_of_week' name='day_of_week' required>
        <p>Task path:</p>
        <input id='taskpath' name='taskpath' required>
        <br><br>
        <button class="btn2" type='submit'>Add task automation</button>
        <br><br>
        <p>Things to take into account: 1) If you enter * the task will be executed every unit of time. 2) 0 and 7 are both Sunday. </p>
    </form>

"

if [ -n "$arguments" ]; then
   
    existing_fcrontab_file=$(sudo fcrontab -l)


    fcrontab_line="$minute $hour $day_of_month $month $day_of_week $taskpath"

    if [ -n "$existing_fcrontab_file" ]; then
        existing_fcrontab_file="$existing_fcrontab_file\n$fcrontab_line"
    else 
        existing_fcrontab_file="$fcrontab_line"
    fi

    #We write the fcrontab file with the previous content plus the new line
    echo -e "$existing_fcrontab_file" | sudo fcrontab -

    fcrontab_table=$(sudo fcrontab -l)
    #echo -e "Result: $fcrontab_table"

fi

echo -e "
    <br>
    <p><b>Fcrontab table</b></p>
    <table border='1'>
        <tr>
            <th>Minute</th><th>Hour</th><th>Day</th><th>Month</th><th>Weekday</th><th>Path</th><th>Delete</th>
        </tr>
    "

while IFS= read -r line; do

    echo "<tr>"
    for i in {1..7}; do

            #For the last cell we create a button to delete the task
            if [ "$i" -eq 7 ]; then
                echo "<td>
                    <form action='../cgi-bin/del_task.sh' method='get'>
                        <button class="btn2" type='submit'>Delete</button>
                        <input type='hidden' id='minute' name='minute' value='$(echo "$line" | awk '{print $1}')'>
                        <input type='hidden' id='hour' name='hour' value='$(echo "$line" | awk '{print $2}')'>
                        <input type='hidden' id='day_of_month' name='day_of_month' value='$(echo "$line" | awk '{print $3}')'>
                        <input type='hidden' id='month' name='month' value='$(echo "$line" | awk '{print $4}')'>
                        <input type='hidden' id='day_of_week' name='day_of_week' value='$(echo "$line" | awk '{print $5}')'>
                        <input type='hidden' id='taskpath' name='taskpath' value='$(echo "$line" | awk '{print $6}')'>
                    </form>
                </td>"
            else 
                echo "<td>$(echo "$line" | awk -v var="$i" '{print $var}')</td>"
            fi
    done
    echo "</tr>"

done <<< "$fcrontab_table"

echo "
    </table>
</body>
</html>
"