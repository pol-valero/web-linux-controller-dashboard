#!/bin/bash

logger -t MYLOGS "Entered LOGS functionality"

logs=$(grep -a MYLOGS /var/log/sys.log)

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

    <h1>Logs</h1>
"

while IFS= read -r line; do
   echo -e "<p>$line</p>"
done <<< "$logs"

echo "
</body>
</html>
"