#!/bin/bash

#We use the psaux command to get the all the current processes information
ps_output=$(ps aux)

echo -e "Content-type: text/html\n\n<html>"

echo -e "
<head>
    <title>Process Information</title>
</head>
<body>
    <h2>Process Information</h2>
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
        </tr>"

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

echo "
</table>
</body>
</html>
"
