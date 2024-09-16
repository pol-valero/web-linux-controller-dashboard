#!/bin/bash

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

    <h1>Shutdown/Reboot</h1>

    <form action='../cgi-bin/shutdown_reboot.sh' method='get'>
        <label>Shutdown/Reboot:</label>
        <select name='option'>
            <option value='shutdown'>Shutdown</option>
            <option value='reboot'>Reboot</option>
        </select>
        <button class="btn2" type='submit'>Execute</button>
    </form>
"

if [ -n "$QUERY_STRING" ]; then

    selected_option=$(echo "$QUERY_STRING" | awk -F'=' '{print $2}')

    if [ "$selected_option" = "reboot" ]; then
        logger -t MYLOGS "Reboot option selected"
        echo -e "<p>Rebooting... You must wait a few moments until the reboot is complete in order to use the server again</p>"
        sudo shutdown -r now
    else
        if [ "$selected_option" = "shutdown" ]; then
            logger -t MYLOGS "Shutdown option selected"
            echo -e "<p>Shutting down... Please, close the website as it will no longer work until the server is turned on again</p>"
            sudo shutdown -h now
        else
            echo -e "<p>Invalid option</p>"
        fi
    fi

fi


echo "
</body>
</html>
"