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

    username=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $2}')
    password=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $4}')

    #We check if the username exists. Getent will not return anything if the user does not exist
    if getent passwd "$username" > /dev/null
    then
        echo -e "<p>This username already exists in the system</p>"
    else
        echo -e "<p>User with username $username created</p>"
        sudo useradd -m "$username"
        echo "$username:$password" | sudo chpasswd
    fi

fi


echo "
</body>
</html>
"