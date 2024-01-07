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
    <h1>Automount music</h1>
"

#The usb partition is listed last in the fdisk command output, when a usb is connected
usb_part=$(sudo fdisk -l | tail -n 1 | awk '{print $1}')

if [ "$usb_part" != "/dev/sda1" ] && [ "$usb_part" != "/dev/sda2" ]; then
   
    echo "Partition: $usb_part. "

    echo "USB connected!"
    
    sudo mount $usb_part /mnt

    #We delete any preexisting files in the usbfiles folder
    sudo rm -rf /usr/lib/httpd/usbfiles/*

    #We copy the .mp3 files from the usb mount folder to the usbfiles folder
    sudo cp -r /mnt/*.mp3 /usr/lib/httpd/usbfiles

    sudo umount /mnt
    #sudo rm -rf /mnt/*

    #We create a folder to store the fileslist.txt file. If the directory already exists, it simply outputs an error and it is not created again
    mkdir /usr/myfiles

    #We delete any preexisting fileslist.txt file
    rm -rf /usr/myfiles/fileslist.txt

    #We generate a file with the names of the .mp3 files from the USB and the path where they are stored, in the usbfiles folder
    touch /usr/myfiles/fileslist.txt

    songs_path="/usr/lib/httpd/usbfiles/"

    echo "<br>"
    echo "<br>"
    echo "<p><b>Songs in the USB: </b></p>"
    echo "<br>"

    num_songs=$(ls /usr/lib/httpd/usbfiles | wc -l);

    if [ $num_songs -eq 0 ]; then
        echo "<p>There are no songs in the USB</p>"
    else

        while IFS= read -r line; do

            echo "Song name: $line" >> /usr/myfiles/fileslist.txt
            echo "Song path: $songs_path$line" >> /usr/myfiles/fileslist.txt
            echo "" >> /usr/myfiles/fileslist.txt
            
            echo "<p>$Song name: $line</p>"
            echo "<p>$Song path: $songs_path$line</p>"
            echo "<br>"

        done <<< "$(ls /usr/lib/httpd/usbfiles)"

    fi

else
    echo "USB not connected"
fi

echo "
</body>
</html>
"