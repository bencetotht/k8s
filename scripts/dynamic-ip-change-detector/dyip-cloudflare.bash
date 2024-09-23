#!/bin/bash

###
ZONE=""
DNS_ID=""
AUTH=""
DOMAIN=""
SLACK_URL=""
###

DIRECTORY=$(pwd)
CURRENT_IP=$(curl ipinfo.io/ip)
if test -f ./ip 
then
    OLD_IP=$(cat $DIRECTORY/ip)
    if [[ "$CURRENT_IP" != "$OLD_IP" ]]
    then
        echo "CHANING IP FROM $OLD_IP TO $CURRENT_IP"
        echo $CURRENT_IP > $DIRECTORY/ip
        json_string='{"type":"A","name":"'"$DOMAIN"'","content":"'"$CURRENT_IP"'","ttl":1,"proxied":false}'
        curl -X PATCH "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records/$DNS_ID" -H "Authorization: $AUTH" -H "Content-Type: application/json" --data $json_string
        curl -X POST -H 'Content-type: application/json' --data '{"text": "SERVER IP CHANGED TO: '$CURRENT_IP' (old ip was '$OLD_IP')"}' $SLACK_URL
    fi
else
    echo "ip file not found, creating..."
    echo $CURRENT_IP > $DIRECTORY/ip
fi