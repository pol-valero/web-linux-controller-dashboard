#!/bin/bash

logger -t MYLOGS "Entered MANAGE USERS functionality"

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

    <h1>Manage users</h1>

"

echo -e "<p><b>Create a user</b></p>
        <form action='../cgi-bin/user_create.sh' method='get'>
            <label>Username:</label>
            <input id='username' name='username' required>
            <label>Password:</label>
            <input id='password' name='password' required>
            <button class="btn2" type='submit'>Create</button>
        </form>
"

echo -e "<p><b>Delete an existing user</b></p>
        <form action='../cgi-bin/user_delete.sh' method='get'>
            <label>Username:</label>
            <input id='username' name='username' required>
            <button class="btn2" type='submit'>Delete</button>
        </form>
"

echo "
</body>
</html>
"