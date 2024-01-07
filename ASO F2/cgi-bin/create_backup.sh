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
    <h1>Create backup</h1>
    <p>The backup will be stored in /usr/myfiles/ and will have the current timestamp as a name</p>
"

echo -e "
    <form action='../cgi-bin/create_backup.sh' method='get'>
        <button class="btn2">Create backup</button>
        <input type="hidden" id="backup" name="backup" value="CREATE">
    </form>
"
query_argument=$(echo "$QUERY_STRING" | awk -F'=' '{print $2}')

if [ "$query_argument" = "CREATE" ]; then
    echo -e "<p>Backup created</p>"
    logs=$(grep -a MYLOGS /var/log/sys.log)
    touch /usr/myfiles/backup_$(date +"%d-%m-%Y_%H:%M:%S").txt
    echo "$logs" >> /usr/myfiles/backup_$(date +"%d-%m-%Y_%H:%M:%S").txt
fi

echo "
</body>
</html>
"