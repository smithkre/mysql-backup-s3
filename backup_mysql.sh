#!/bin/bash

set -e
set -o pipefail

>&2 echo "-----"

# Use the BACKUP_BASE environment variable, default to "/backups" if not set
backup_base="${BACKUP_BASE:-/backups}"

# Get today's date in YYYYMMDD format
today=$(date +%Y%m%d)

# Create a directory for today's backups
backup_dir="${backup_base}/${today}"
rm -rf "${backup_dir}"
mkdir -p "${backup_dir}"

export AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$S3_REGION

# Loop through and dump each database
for db in $DATABASE_NAME; do
    echo "Dumping database: $db"
    mysqldump --ssl=FALSE -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD --databases $db > "${backup_dir}/${db}.sql"
    tar -czvf "${backup_dir}/${db}.sql.tar.gz" -C "${backup_dir}" "${db}.sql"
    # Upload to DigitalOcean Spaces
    aws s3 cp "${backup_dir}/${db}.sql.tar.gz" s3://$S3_BUCKET/${today}-${db}.sql.tar.gz --endpoint-url $S3_ENDPOINT
done

# Delete local backup files after upload
rm -rf "${backup_dir}"

older_than=$(date --date="30 days ago" +%Y%m%d)
aws s3 rm s3://$S3_BUCKET --recursive --endpoint-url $S3_ENDPOINT --exclude "*" --include "${older_than}/*"