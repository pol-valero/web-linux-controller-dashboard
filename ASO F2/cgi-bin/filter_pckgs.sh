#!/bin/bash


#We get this values from the page where we add rules to the filter tables
table=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $2}')
target=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $4}')
protocol=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $6}')
sourceip=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $8}')
destinationip=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $10}')
sourceport=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $12}')
destinationport=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $14}')
interface=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $16}')

command_arguments=""

#We check if the user has entered a value for each field and we add it to the command arguments
if [ -n "$sourceip" ]; then
    command_arguments="-s $sourceip"
fi

if [ -n "$destinationip" ]; then
    command_arguments="$command_arguments -d $destinationip"
fi

if [ -n "$interface" ]; then
    command_arguments="$command_arguments -i $interface"
fi

if [ -n "$protocol" ]; then
    command_arguments="$command_arguments -p $protocol"
fi

if [ -n "$sourceport" ]; then
    command_arguments="$command_arguments --sport $sourceport"
fi

if [ -n "$destinationport" ]; then
    command_arguments="$command_arguments --dport $destinationport"
fi

sudo iptables -A $table $command_arguments -j $target


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

    <h1>Filter Packages</h1>
    
"

#OUTPUT TABLE-----------------------

output_table=$(sudo iptables -L OUTPUT -n --line-numbers)

echo -e "
    <p><b>Current OUTPUT table</b></p>
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
done <<< "$output_table"

echo "
    </table>

    <form action='../cgi-bin/edit_out_filter.sh' method='get'>
        <button class="btn2">Add OUTPUT filter rules</button>
        <input type="hidden" id="table" name="table" value="OUTPUT">
        <input type="hidden" id="data" name="data" value="ADD">
    </form>

    <form action='../cgi-bin/edit_out_filter.sh' method='get'>
        <button class="btn2">Delete OUTPUT filter rules</button>
        <input type="hidden" id="table" name="table" value="OUTPUT">
        <input type="hidden" id="data" name="data" value="DELETE">
    </form>
    "
#-----------------------------------

#FORWARD TABLE-----------------------

forward_table=$(sudo iptables -L FORWARD -n --line-numbers)

echo -e "
    <p><b>Current FORWARD table</b></p>
    <table border='1'>
        <tr>
            <th>Line</th><th>Target</th> <th>Prot</th><th>Opt</th><th>Source</th><th>Destination</th><th>Options</th>
        </tr>
    "

while IFS= read -r line; do

    #We omit the first to lines of the iptable forward
    if [ "$(echo "$line" | grep -c '^num')" -eq 0 ] && [ "$(echo "$line" | grep -c '^Chain')" -eq 0 ]; then

        echo "<tr>"
        for i in {1..7}; do
            #For the last cell we put the last two columns of the forward together
            if [ "$i" -eq 7 ]; then
                echo "<td>$(echo "$line" | awk '{print $7,$8}')</td>"
            else 
                echo "<td>$(echo "$line" | awk -v var="$i" '{print $var}')</td>"
            fi
        done
        echo "</tr>"
    fi
done <<< "$forward_table"

echo "
    </table>

    <form action='../cgi-bin/edit_out_filter.sh' method='get'>
        <button class="btn2">Add FORWARD filter rules</button>
        <input type="hidden" id="table" name="table" value="FORWARD">
        <input type="hidden" id="data" name="data" value="ADD">
    </form>

    <form action='../cgi-bin/edit_out_filter.sh' method='get'>
        <button class="btn2">Delete FORWARD filter rules</button>
        <input type="hidden" id="table" name="table" value="FORWARD">
        <input type="hidden" id="data" name="data" value="DELETE">
    </form>
    "
#-----------------------------------


#INPUT TABLE-----------------------

input_table=$(sudo iptables -L INPUT -n --line-numbers)

echo -e "
    <p><b>Current INPUT table</b></p>
    <table border='1'>
        <tr>
            <th>Line</th><th>Target</th> <th>Prot</th><th>Opt</th><th>Source</th><th>Destination</th><th>Options</th>
        </tr>
    "

while IFS= read -r line; do

    #We omit the first to lines of the iptable input
    if [ "$(echo "$line" | grep -c '^num')" -eq 0 ] && [ "$(echo "$line" | grep -c '^Chain')" -eq 0 ]; then

        echo "<tr>"
        for i in {1..7}; do
            #For the last cell we put the last two columns of the input together
            if [ "$i" -eq 7 ]; then
                echo "<td>$(echo "$line" | awk '{print $7,$8}')</td>"
            else 
                echo "<td>$(echo "$line" | awk -v var="$i" '{print $var}')</td>"
            fi
        done
        echo "</tr>"
    fi
done <<< "$input_table"

echo "
    </table>

    <form action='../cgi-bin/edit_out_filter.sh' method='get'>
        <button class="btn2">Add INPUT filter rules</button>
        <input type="hidden" id="table" name="table" value="INPUT">
        <input type="hidden" id="data" name="data" value="ADD">
    </form>

    <form action='../cgi-bin/edit_out_filter.sh' method='get'>
        <button class="btn2">Delete INPUT filter rules</button>
        <input type="hidden" id="table" name="table" value="INPUT">
        <input type="hidden" id="data" name="data" value="DELETE">
    </form>
    "
#-----------------------------------

echo "

</body>
</html>
"