#!/bin/bash

# -------------------------------
# CONFIGURATION
# -------------------------------
PG_USER="barman"
PG_HOST="192.168.88.57"
PG_PORT="5432"

# Databases and tables to dump
DATABASES=("db1" "db2" "db3")
declare -A TABLES
TABLES["db1"]="table1 table2"
TABLES["db2"]="table3 table4"
# S3 bucket
S3_BUCKET="s3://your-bucket-name/backups"
# Backup destination
BACKUP_DIR="/tmp/pg_backups"
mkdir -p "$BACKUP_DIR"


TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# DUMP DATABASES
for DB in "${DATABASES[@]}"; do
    DB_BACKUP_DIR="$BACKUP_DIR/$DB"
    mkdir -p "$DB_BACKUP_DIR"

    if [[ -n "${TABLES[$DB]}" ]]; then
        for TABLE in ${TABLES[$DB]}; do
            FILENAME="$DB_BACKUP_DIR/${TABLE}_${TIMESTAMP}.dump"
            echo "Dumping table $TABLE from database $DB..."
            pg_dump -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$DB" -t "$TABLE" -F c -f "$FILENAME"
        done
    else
        FILENAME="$DB_BACKUP_DIR/${DB}_${TIMESTAMP}.dump"
        echo "Dumping entire database $DB..."
        pg_dump -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$DB" -F c -f "$FILENAME"
    fi
done

echo "Compressing backups..."
tar -czf "$BACKUP_DIR/postgres_backup_$TIMESTAMP.tar.gz" -C "$BACKUP_DIR" .

# UPLOAD TO S3
echo "Uploading backup to S3..."
aws s3 cp "$BACKUP_DIR/postgres_backup_$TIMESTAMP.tar.gz" "$S3_BUCKET/"

# CLEANUP
echo "Cleaning up local backup files..."
rm -rf "$BACKUP_DIR"

echo "Backup completed successfully!"
