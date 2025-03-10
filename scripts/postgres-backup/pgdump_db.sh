#!/bin/bash

DB_NAME=$1

pg_dump -U barman -h 192.168.88.57 -p 5432 -d ${DB_NAME} -F c -f /backups/DB_${DB_NAME}_$(date +%F).dump
echo "Backup completed on $(date +%F) for database ${DB_NAME}"