ARG ALPINE_TAG=latest
FROM alpine:$ALPINE_TAG

WORKDIR /projects

ARG DEV_USER
ARG DEV_UID
ARG DEV_GID

ENV DEV_USER=$DEV_USER \
    DEV_UID=$DEV_UID \
    DEV_GID=$DEV_GID \
    SSH_AUTH_SOCK=/home/${DEV_USER}/.ssh/socket

## Install and setup
######################

RUN \
    # Create user and group
    addgroup $DEV_USER \
    && adduser \
    --shell /bin/bash \
    --disabled-password \
    --gecos "${DEV_USER}" \
    --ingroup ${DEV_USER} \
    -u ${DEV_UID} \
    ${DEV_USER} \
    # Setup the user to be able to access docker
    && addgroup docker -g 1001 \
    && addgroup $DEV_USER docker \
    && apk update && \
    apk add --no-cache \
    # Git clone repos  [10.84 MB]
    git \
    # Tar (de)compress files  [540 kB]
    tar \
    # Openssh-client can use agent forwarding [2.34 MB]
    openssh-client \
    # Curl fetch things from api's [256 kB]
    curl \
    # Sed manipulate text files in script [160 kB]
    sed \
    # Jq manipulate json files in script [560 kB]
    jq \
    # Htop show system resources [308 kB]
    htop \
    # Utilize standard bash scripts [1.27 MB]
    bash \
    # neofetch show system info (includes bash) [348 kB]
    neofetch \
    # cmatrix just for fun [36.00 KB]
    cmatrix \
    # Docker-cli to access docker host [41.17 MB]
    docker-cli \
    # Socat for ssh agent forawrding [208.51 kB]
    socat \
    # Su-exec is used to switch to none root in docker-entrypoint.sh [16 kB]
    su-exec \
    && echo "net.ipv4.ping_group_range = 0 $DEV_GID" >> /etc/sysctl.conf

## Files and folders
######################

# Copy entrypoint scripts for docker
COPY ./base-developer/run-scripts/docker-entrypoint*.sh /
# Copy ssh known hosts for github
COPY ./base-developer/.ssh /home/${DEV_USER}/.ssh
#  Folder to store docker sock that is used by socat
RUN mkdir -p /home/${DEV_USER}/.docker/

## Permissions
######################

# Fix permissions owner to DEV_USER and that entrypoint is executable
RUN chown -R ${DEV_UID}:${DEV_GID} /home/${DEV_USER} \
    && chown ${DEV_UID}:${DEV_GID} /projects \
    && chmod +x /docker-entrypoint.sh

## Startup
######################

CMD ["bypass"]
ENTRYPOINT ["/docker-entrypoint.sh"]
