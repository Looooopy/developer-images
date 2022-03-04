ARG ALPINE_TAG=latest
FROM alpine:$ALPINE_TAG

ARG DEV_USER
ARG DEV_UID
ARG DEV_GID

ENV DEV_USER=$DEV_USER \
    DEV_UID=$DEV_UID \
    DEV_GID=$DEV_GID

RUN addgroup $DEV_USER \
    && adduser \
    --shell /bin/bash \
    --disabled-password \
    --gecos "${DEV_USER}" \
    --ingroup ${DEV_USER} \
    -u ${DEV_UID} \
    ${DEV_USER}
RUN addgroup docker -g 1001
RUN addgroup $DEV_USER docker

RUN apk update && \
    apk add --no-cache \
    git \
    tar \
    openssh-client \
    curl \
    sed \
    jq \
    htop \
    bash \
    # neofetch includes bash
    neofetch \
    cmatrix && \
    echo "net.ipv4.ping_group_range = 0 1000" >> /etc/sysctl.conf

COPY ./base-developer/docker-entrypoint.sh /docker-entrypoint.sh
COPY ./run-scripts/docker-entrypoint-helper.sh /docker-entrypoint-helper.sh

# Socat used to access SSH Agent forwarding.
# su-exec is used to switch to none root in docker-entrypoint.sh
ENV SSH_AUTH_SOCK=/home/${DEV_USER}/.ssh/socket
RUN apk add --no-cache \
        socat su-exec && \
    mkdir -p /home/${DEV_USER}/.ssh && \
    chown ${DEV_UID}:${DEV_GID} /home/${DEV_USER}/.ssh/

RUN mkdir -p /projects && chown ${DEV_UID}:${DEV_GID} /projects

WORKDIR /projects

ENTRYPOINT ["/docker-entrypoint.sh"]