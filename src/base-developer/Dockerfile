ARG ALPINE_TAG=latest
FROM alpine:$ALPINE_TAG

ARG DEV_USER
ARG DEV_UID
ARG DEV_GID

ENV DEV_USER=$DEV_USER \
    DEV_UID=$DEV_UID \
    DEV_GID=$DEV_GID \
    SSH_AUTH_SOCK=/home/${DEV_USER}/.ssh/socket

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
    cmatrix \
    # required: socat for ssh agent forawrding
    socat \
    # required: su-exec is used to switch to none root in docker-entrypoint.sh
    su-exec \
    && echo "net.ipv4.ping_group_range = 0 $DEV_GID" >> /etc/sysctl.conf

COPY ./base-developer/run-scripts/docker-entrypoint*.sh /

# Adding known hosts: github
COPY ./base-developer/.ssh /home/${DEV_USER}/.ssh

# Workdir needs to be ser before chown
WORKDIR /projects

# Fix permissions so its owned by DEV_USER
RUN chown ${DEV_UID}:${DEV_GID} /home/${DEV_USER} \
    && chown ${DEV_UID}:${DEV_GID} /projects

CMD ["bypass"]
ENTRYPOINT ["/docker-entrypoint.sh"]
