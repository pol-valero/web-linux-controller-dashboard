#!/bin/bash

echo "Content-Type: text/html"

echo -e "

<!doctype html>

<html>
<head>
    <link rel="stylesheet" href="../css/styles.css">
    <h1>Login status: </h1>
</head>
<body>
"

#We use awk to parse the query string
username=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $2}')
password=$(echo "$QUERY_STRING" | awk -F'[=&?]' '{print $4}')

#We check if the username exists. Getent will not return anything if the user does not exist
if getent passwd "$username" > /dev/null
then
    
    #We get the hashed password from the shadow file
    hashed_existing_password=$(getent shadow "$username" | cut -d ":" -f 2)
    #We get the salt from the hashed password
    salt=$(echo "$hashed_existing_password" | cut -d'$' -f3)
    #We hash the entered password with the salt
    hashed_entered_password=$(echo "$password" | openssl passwd -5 -salt "$salt" -stdin)

    #print username 
    echo -e "<p>Username: $username</p>"

    #We check if the password is correct looking at the passwd file
    if [ "$hashed_entered_password" = "$hashed_existing_password" ];
    then
        echo -e "<p>Login successful</p>"
        echo -e "
            <form action="../html/home.html" method="get">
            <button type="submit">Enter the system</button>
            </form>
        "
        logger -t MYLOGS "User $username successfully logged in"
    else
        echo -e "<p>Wrong password</p>"
        echo -e "
            <form action="../html/login.html" method="get">
            <button type="submit">Go back</button>
            </form>
        "
        logger -t MYLOGS "User $username tried to log in with wrong password"
    fi
    
else
    echo -e "<p>User does not exist</p>"
    echo -e "
            <form action="../html/login.html" method="get">
            <button type="submit">Go back</button>
            </form>
        "
    logger -t MYLOGS "User $username tried to log in but username does not exist"
fi

echo -e "

</body>
</html>

"