# asterisk17
#Dockerfile that builds Asterisk version 17.

If you are not passing in your own config files, first start the container without any volumes added, then copy required files out of the container with docker-cp command.

    docker cp asterisk:/etc/asterisk asterisk/config 
    docker cp asterisk:/var/lib/asterisk asterisk/lib    
    docker cp asterisk:/var/spool/asterisk asterisk/data
    
Then restart container with volumes added. 
