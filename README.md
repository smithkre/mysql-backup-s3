# backup-s3

Backup Data to S3 (supports periodic backups)

## Basic Usage

```
S3_ACCESS_KEY_ID:
S3_SECRET_ACCESS_KEY:
S3_BUCKET:
S3_REGION: sgp
S3_ENDPOINT:

MODE mysql | file | postgres

POSTGRES_DATABASE:
POSTGRES_HOST:
POSTGRES_PORT:
POSTGRES_USER:
POSTGRES_PASSWORD:
POSTGRES_EXTRA_OPTS:

MYSQL_HOST:
MYSQL_USER:
MYSQL_PASSWORD:

DATABASE_NAME:

FOLDER:

SCHEDULE **None**

```

## User this for sync file only last xxx day

```
#! /bin/sh

set -e
set -o pipefail

>&2 echo "-----"

export AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$S3_REGION

mkdir /tmp_folder
for folder in $FOLDER; do
    find "/${folder}" -type f -mtime -30 -exec cp {} "/tmp_folder" \;
    aws s3 sync /tmp_folder s3://$S3_BUCKET/$folder --endpoint-url $S3_ENDPOINT
    rm -rf "/tmp_folder"
done
```

In volume file

```
      MODE: file
      FOLDER: "data"
    volumes:
      - ./backup.sh:/backup_file.sh
      - /mnt/data/:/data
```
