#!/bin/bash

DIRECTORY=$(pwd)
CURRENT_IP=$(curl ipinfo.io/ip)
if test -f ./ip 
then
    OLD_IP=$(cat $DIRECTORY/ip)
    if [[ "$CURRENT_IP" != "$OLD_IP" ]]
    then
        echo $CURRENT_IP > $DIRECTORY/ip
        curl -X POST -H 'Content-type: application/json' --data '{"text": "SERVER IP CHANGED TO: '$CURRENT_IP' (old ip was '$OLD_IP')"}' <SLACK-URL>
    fi
else
    echo $CURRENT_IP > DIRECTORY/ip
fi