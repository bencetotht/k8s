#!/bin/bash

DB_NAME=$1
TABLE_NAME=$2

pg_dump -U barman -h 192.168.88.57 -p 5432 -d ${DB_NAME} -t ${TABLE_NAME} -F c -f /backups/${TABLE_NAME}_$(date +%F).dump
echo "Backup completed on $(date +%F) for table ${TABLE_NAME} on database ${DB_NAME}"