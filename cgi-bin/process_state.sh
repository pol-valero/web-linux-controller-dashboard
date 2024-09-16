#!/bin/bash

logger -t MYLOGS "Process state consulted"

readable_process_state() {
    case "$1" in
        "R")
            echo "Running"
            ;;
        "S")
            echo "Sleeping"
            ;;
        "D")
            echo "Disk Sleep"
            ;;
        "I")
            echo "Idle"
            ;;
        "Z")
            echo "Zombie"
            ;;
        "T")
            echo "Stopped"
            ;;
        "t")
            echo "Tracing/Stopped"
            ;;
        "W")
            echo "Paging"
            ;;
        "X")
            echo "Dead"
            ;;
        *)
            echo "Unknown state"
            ;;
    esac
}

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
    else
        process_state=$(ps -p "$input_pid" -o state --no-headers)

        readable_process_state=$(readable_process_state "$process_state")

        echo "<p>Process with PID $input_pid state: $readable_process_state ($process_state)</p>"
    fi

fi

echo "
</body>
</html>
"