#! /bin/sh

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

export PGPASSWORD=$POSTGRES_PASSWORD
POSTGRES_HOST_OPTS="-h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER $POSTGRES_EXTRA_OPTS"

for db in $DATABASE_NAME; do
    echo "Dumping database: $db"
    pg_dump $POSTGRES_HOST_OPTS $db | gzip > "${backup_dir}/${db}.sql"
    tar -czvf "${backup_dir}/${db}.sql.tar.gz" -C "${backup_dir}" "${db}.sql"
    aws s3 cp "${backup_dir}/${db}.sql.tar.gz" s3://$S3_BUCKET/${today}-${db}.sql.tar.gz --endpoint-url $S3_ENDPOINT
done

older_than=$(date --date="30 days ago" +%Y%m%d)
aws s3 rm s3://$S3_BUCKET --recursive --endpoint-url $S3_ENDPOINT --exclude "*" --include "${older_than}/*"