#!/bin/bash

logger -t MYLOGS "Delete process entered"

echo -e "Content-type: text/html"

echo -e "
<!doctype html>
<html>
<head>
    <link rel="stylesheet" href="../css/styles.css">
    <form action="../cgi-bin/mng_processes.sh" method="get">
        <button type="submit">Go back</button>
    </form>
</head>

<body>
"

if [ -n "$QUERY_STRING" ]; then

    input_pid=$(echo "$QUERY_STRING" | awk -F'=' '{print $2}')

    if ! ps -p "$input_pid" > /dev/null; then
        echo "Process with PID $input_pid does not exist"
        logger -t MYLOGS "PID of process to delete does not exist"
    else

        echo "<p>Process with PID $input_pid is being killed</p>"
        sudo kill -9 "$input_pid"

        #We check the status of the last command to see if it was successful
        if [ $? -eq 0 ]; then
            
            echo "<p>Process with PID $input_pid has been killed</p>"
            logger -t MYLOGS "Process has been deleted"
          
        else
            echo "<p>ERROR: Process with PID $input_pid could not be killed</p>"
            logger -t MYLOGS "Error while deleting process"
        fi
    
    fi

fi

echo "
</body>
</html>
"