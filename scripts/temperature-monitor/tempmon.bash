#!/bin/bash

THRESHOLD=70
LINES=$(sensors | grep ' C ' | cut -d '+' -f2 | cut -d 'C' -f1 | awk '$1 >= '$THRESHOLD' { print $1 }' | wc -l)
# ALTERNATIVE VERSION with: grep '°C '
echo "Checking with threshold: $THRESHOLD"
if [ "$LINES" != 0 ]
then
    curl -X POST -H 'Content-type: application/json' --data '{"text": "'$HOSTNAME' SERVER TEMPERATURES OVER THRESHOLD '$THRESHOLD' "}' <SLACK-URL>
fi