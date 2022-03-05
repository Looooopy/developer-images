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
    # Git clone repos
    git \
    # Tar (de)compress files
    tar \
    # Openssh-client can use agent forwarding
    openssh-client \
    # Curl fetch things from api's
    curl \
    # Sed manipulate text files in script
    sed \
    # Jq manipulate json files in script
    jq \
    # Htop show system resources
    htop \
    # Utilize standard bash scripts
    bash \
    # neofetch show system info (includes bash)
    neofetch \
    # cmatrix just for fun
    cmatrix \
    # Docker-cli to access docker host
    docker-cli \
    # Socat for ssh agent forawrding
    socat \
    # Su-exec is used to switch to none root in docker-entrypoint.sh
    su-exec \
    && echo "net.ipv4.ping_group_range = 0 $DEV_GID" >> /etc/sysctl.conf

## Files and folders
######################

# Add entrypoint script for docker
COPY ./base-developer/run-scripts/docker-entrypoint*.sh /
# Add ssh known hosts: github
COPY ./base-developer/.ssh /home/${DEV_USER}/.ssh
#  Fodler to stor docker_sock useb by socat
RUN mkdir -p /home/${DEV_USER}/.docker/

## Permissions
######################

# Fix permissions so its owned by DEV_USER and that entrypoint is executable
RUN chown -R ${DEV_UID}:${DEV_GID} /home/${DEV_USER} \
    && chown ${DEV_UID}:${DEV_GID} /projects \
    && chmod +x /docker-entrypoint.sh

## Startup
######################

CMD ["bypass"]
ENTRYPOINT ["/docker-entrypoint.sh"]
