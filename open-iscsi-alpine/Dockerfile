# Installs a pinned open-iscsi version into alpine
# Seems like the open-iscsi version needed (2.1.2) is not available on the
# latest alpine image. TODO: Upgrade the image along with the open-iscsi version
# when a higher release is tested to work.
FROM alpine:3.12

ENV VERSION=2.1.2-r0
RUN apk add --no-cache open-iscsi==${VERSION}

ENTRYPOINT ["/sbin/iscsid"]
