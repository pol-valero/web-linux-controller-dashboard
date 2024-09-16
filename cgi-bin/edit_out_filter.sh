#!/bin/bash

table=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $2}')
action=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $4}')

echo -e "Content-type: text/html"

echo -e "
<!doctype html>
<html>
<head>
    <link rel="stylesheet" href="../css/styles.css">
    <form action="../cgi-bin/filter_pckgs.sh" method="get">
        <button type="submit">Go back</button>
    </form>
</head>

<body>

    <h1>Edit $table filter rules</h1>
"

if [ $action = "ADD" ]; then

    logger -t MYLOGS "Entered ADD_FILTER functionality"

    echo -e "
        <form action='../cgi-bin/filter_pckgs.sh' method='get'>
            <input type="hidden" id="table" name="table" value="$table">
            <label>Target</label>
            <select name='target'>
                <option value='ACCEPT'>ACCEPT</option>
                <option value='DROP'>DROP</option>
                <option value='REJECT'>REJECT</option>
            </select>
            <br><br>
            <label>Protocol</label>
            <select name='protocol'>
                <option value='tcp'>TCP</option>
                <option value='udp'>UDP</option>
                <option value='icmp'>ICMP</option>
            </select>
            <br><br>
            <label>Source IP</label>
            <input type='text' name='sourceip'>
            <label>Destination IP</label>
            <input type='text' name='destinationip'>
            <br><br>
            <label>Source port</label>
            <input type='text' name='sourceport'>
            <label>Destination port</label>
            <input type='text' name='destinationport'>
            <br><br>
            <label>Interface</label>
            <input type='text' name='interface'>
            <br><br>
            <button class='btn2' type='submit'>Add</button>
    "

else 
    logger -t MYLOGS "Filter deleted"

    echo "<p>All the OUTPUT table rules have been deleted</p>"
    sudo iptables -F $table

fi


#TABLE-----------------------

table_loaded=$(sudo iptables -L $table -n --line-numbers)

echo -e "
    <p><b>Current $table table</b></p>
    <table border='1'>
        <tr>
            <th>Line</th><th>Target</th> <th>Prot</th><th>Opt</th><th>Source</th><th>Destination</th><th>Options</th>
        </tr>
    "

while IFS= read -r line; do

    #We omit the first to lines of the iptable output
    if [ "$(echo "$line" | grep -c '^num')" -eq 0 ] && [ "$(echo "$line" | grep -c '^Chain')" -eq 0 ]; then

        echo "<tr>"
        for i in {1..7}; do
            #For the last cell we put the last two columns of the output together
            if [ "$i" -eq 7 ]; then
                echo "<td>$(echo "$line" | awk '{print $7,$8}')</td>"
            else 
                echo "<td>$(echo "$line" | awk -v var="$i" '{print $var}')</td>"
            fi
        done
        echo "</tr>"
    fi
done <<< "$table_loaded"

echo "
    </table>
    "
#------------------------------

echo "

</body>
</html>
"