FROM alpine:3.18

RUN apk update \
	&& apk upgrade \
	&& apk add coreutils tar mysql-client postgresql15-client aws-cli openssl dcron \
	&& rm -rf /var/cache/apk/*

ENV S3_ACCESS_KEY_ID **None**
ENV S3_SECRET_ACCESS_KEY **None**
ENV S3_BUCKET **None**
ENV S3_REGION us-west-1
ENV S3_ENDPOINT **None**

ENV MODE mysql

ENV POSTGRES_DATABASE **None**
ENV POSTGRES_HOST **None**
ENV POSTGRES_PORT 5432
ENV POSTGRES_USER **None**
ENV POSTGRES_PASSWORD **None**
ENV POSTGRES_EXTRA_OPTS ''

ENV MYSQL_HOST **None**
ENV MYSQL_USER **None**
ENV MYSQL_PASSWORD **None**
ENV DATABASE_NAME **None**

ENV SCHEDULE **None**

ADD run.sh /run.sh
ADD backup_mysql.sh /backup_mysql.sh
ADD backup_postgres.sh /backup_postgres.sh
ADD backup_file.sh /backup_file.sh

CMD ["sh", "/run.sh"]
