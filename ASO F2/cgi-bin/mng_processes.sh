#!/bin/bash

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
        <form action='../cgi-bin/process_state.sh' method='get'>
            <label>PID:</label>
            <input id='pid' name='pid' required>
            <button class="btn2" type='submit'>Consult</button>
        </form>
"


echo -e "<p><b>Interrupt process</b></p>
        <form action='../cgi-bin/process_interrupt.sh' method='get'>
            <label>PID:</label>
            <input id='pid' name='pid' required>
            <label>Time:</label>
            <input id='time' name='time' required>
            <button class="btn2" type='submit'>Interrupt</button>
        </form>
"

echo -e "<p><b>Delete process</b></p>
        <form action='../cgi-bin/process_delete.sh' method='get'>
            <label>PID:</label>
            <input id='pid' name='pid' required>
            <button class="btn2" type='submit'>Delete</button>
        </form>
"


echo "
</body>
</html>
"
