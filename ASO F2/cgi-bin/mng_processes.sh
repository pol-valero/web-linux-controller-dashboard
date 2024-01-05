#!/bin/bash

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

#We use the psaux command to get the all the current processes information
ps_output=$(ps aux)

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

    <h1>Manage processes</h1>

    <p><b>Current processes</b></p>

    <table border='1'>
        <tr>
            <th>User</th>
            <th>PID</th>
            <th>%CPU</th>
            <th>%MEM</th>
            <th>VSZ</th>
            <th>RSS</th>
            <th>TTY</th>
            <th>STAT</th>
            <th>START</th>
            <th>TIME</th>
            <th>COMMAND</th>
        </tr>
"

#The while loop is used to read the output of the psaux command line by line
while IFS= read -r line; do
    if [ "$(echo "$line" | grep -c '^USER')" -eq 0 ]; then
        echo "<tr>"
        for i in {1..11}; do
            echo "<td>$(echo "$line" | awk -v var="$i" '{print $var}')</td>"
        done
        echo "</tr>"
    fi
done <<< "$ps_output"

echo "</table>"

echo -e "<p><b>Consult process state</b></p>
        <form action='../cgi-bin/mng_processes.sh' method='get'>
            <label>PID:</label>
            <input id='pid' name='pid'><br><br>
            <button class="btn2" type='submit'>Consult</button>
"
if [ -n "$QUERY_STRING" ]; then

    input_pid=$(echo "$QUERY_STRING" | awk -F'=' '{print $2}')

    process_state=$(ps -p "$input_pid" -o state --no-headers)

    readable_process_state=$(readable_process_state "$process_state")

    echo "<p>Process with PID $input_pid state: $readable_process_state ($process_state)</p>"

fi


echo "
</body>
</html>
"
