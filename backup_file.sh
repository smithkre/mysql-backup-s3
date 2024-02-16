#! /bin/sh

set -e
set -o pipefail

>&2 echo "-----"

export AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$S3_REGION

for folder in $FOLDER; do
    aws s3 sync /$folder s3://$S3_BUCKET/$folder --endpoint-url $S3_ENDPOINT
done
