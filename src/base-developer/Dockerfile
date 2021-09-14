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
        neofetch \
        cmatrix

# Setup git with your credentials
# Required input Github Personal access tokens
# Generate SSH Key upload public key (Or should this be an input? through lastpass?)
# Generate a GPG keys so we can start signing things (Or should this be an input? through lastpass?)