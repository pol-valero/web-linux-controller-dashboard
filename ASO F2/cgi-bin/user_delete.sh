#!/bin/bash

echo -e "Content-type: text/html"

echo -e "
<!doctype html>
<html>
<head>
    <link rel="stylesheet" href="../css/styles.css">
    <form action="../cgi-bin/mng_users.sh" method="get">
        <button type="submit">Go back</button>
    </form>
</head>

<body>
"
if [ -n "$QUERY_STRING" ]; then

    username=$(echo "$QUERY_STRING" | awk -F'=' '{print $2}')

    if getent passwd "$username" > /dev/null
    then
        echo -e "<p>User with username $username deleted</p>"
        sudo userdel -r "$username"
        logger -t MYLOGS "Deleted user"
    else
        echo -e "<p>This username does not exist in the system</p>"
        logger -t MYLOGS "Error while deleting user, the username does not exist in the system"
    fi

fi

echo "
</body>
</html>
"