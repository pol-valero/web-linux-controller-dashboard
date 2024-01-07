#!/bin/bash

logger -t MYLOGS "Interrupt process entered"

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

    input_pid=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $2}')

    input_time=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $4}')

    if ! ps -p "$input_pid" > /dev/null; then
        echo "Process with PID $input_pid does not exist"
        logger -t MYLOGS "PID of process to interrupt does not exist"
    else

        echo "<p>Process with PID $input_pid is being paused for $input_time seconds</p>"
        sudo kill -s SIGSTOP "$input_pid"

        #We check the status of the last command to see if it was successful
        if [ $? -eq 0 ]; then
            sleep "$input_time"
            sudo kill -s SIGCONT "$input_pid"
            if [ $? -eq 0 ]; then
                echo "<p>Process with PID $input_pid has been resumed</p>"
                logger -t MYLOGS "Process has been resumed"
            else
                echo "<p>ERROR: Process with PID $input_pid could not be resumed</p>"
                logger -t MYLOGS "Error while resuming process"
            fi
        else
            echo "<p>ERROR: Process with PID $input_pid could not be paused</p>"
            logger -t MYLOGS "Error while pausing process"
        fi
    
    fi

fi

echo "
</body>
</html>
"