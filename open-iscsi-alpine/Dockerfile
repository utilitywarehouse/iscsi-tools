# Installs a pinned open-iscsi version into alpine
FROM alpine:3.12

ENV VERSION=2.1.2-r0
RUN apk add --no-cache open-iscsi==${VERSION}

ENTRYPOINT ["/sbin/iscsid"]
