ARG ALPINE_TAG=latest
########## toolchain ##########
FROM base-developer:$ALPINE_TAG as toolchain
RUN apk update && \
    apk add --no-cache \
    build-base \
    cmake \
    automake \
    autoconf \
    pkgconfig \
    libtool \
    coreutils \
    unzip \
    gettext-tiny-dev

########## tmux-build ##########
FROM toolchain as tmux-build
WORKDIR /tmux

## Add additional dependencies for tmux (may be moved into toolchain)
RUN apk add --no-cache \
    libevent-dev \
    ncurses-dev \
    byacc

ARG DEV_USER
ARG DEV_UID
ARG DEV_GID


ENV USER=$DEV_USER \
    UID=${DEV_UID} \
    GID=${DEV_GID} \
    USERNAME=$DEV_USER

ARG STD_XDG_DATA_HOME=/home/$DEV_USER/.local/share
ARG STD_XDG_CONFIG_HOME=/home/$DEV_USER/.local/share

ARG TMUX_GIT_BRANCH=3.2a
ARG TMUX_OUTPUT_DIR=/tmux/tmux-install
ARG TMUX_RESURRECT_PROCESSES
ARG TMUX_XDG_DATA_HOME=$STD_XDG_DATA_HOME
ARG TMUX_XDG_CONFIG_HOME=$STD_XDG_CONFIG_HOME

ENV TMUX_OUTPUT=$TMUX_OUTPUT_DIR \
    TMUX_RESURRECT_PROCESSES=$TMUX_RESURRECT_PROCESSES \
    XDG_DATA_HOME=$TMUX_XDG_DATA_HOME \
    XDG_CONFIG_HOME=$TMUX_XDG_CONFIG_HOME

ARG FORCE_UPDATE_PLUGINS=no

RUN git clone https://github.com/tmux/tmux.git --branch $TMUX_GIT_BRANCH . \
## Git Clone the .tmux config (Should we fork it or create our own?)
    && git clone https://github.com/gpakosz/.tmux.git \
## Uncomment all plugins and continuum-restore to enable them
    && sed -i '/^#set -g @plugin /s/^#//g' /tmux/.tmux/.tmux.conf.local \
    && sed -i '/^#set -g @continuum-restore /s/^#//g' /tmux/.tmux/.tmux.conf.local \
## Uncomment to get the corect symbols inside of tmux status bar
    && sed -i '/^#tmux_conf_theme_right/s/^#//g' /tmux/.tmux/.tmux.conf.local \
    && sed -i '/^#tmux_conf_theme_left/s/^#//g' /tmux/.tmux/.tmux.conf.local \
## Comment
    && sed -i '/^tmux_conf_theme_left_separator_main="/s/^#*/#/g' /tmux/.tmux/.tmux.conf.local \
    && sed -i '/^tmux_conf_theme_left_separator_sub="/s/^#*/#/g' /tmux/.tmux/.tmux.conf.local \
    && sed -i '/^tmux_conf_theme_right_separator_sub="/s/^#*/#/g' /tmux/.tmux/.tmux.conf.local \
    && sed -i '/^tmux_conf_theme_right_separator_main="/s/^#*/#/g' /tmux/.tmux/.tmux.conf.local \
## Turn on ressurect processes if not empty
    && [[ ${TMUX_RESURRECT_PROCESSES+x} == x ]] \
        && sed -i "s/\(set -g @continuum-restore 'on'\)/set -g @continuum-restore-max-delay '2 5'\n\1/g" /tmux/.tmux/.tmux.conf.local \
        && sed -i "s/\(set -g @continuum-restore 'on'\)/set -g @resurrect-processes '$TMUX_RESURRECT_PROCESSES'\n\1/g" /tmux/.tmux/.tmux.conf.local
#        && sed -i "/set -g @continuum-restore 'on'/a set -g @resurrect-processes '$TMUX_RESURRECT_PROCESSES'" /tmux/.tmux/.tmux.conf.local

RUN ./autogen.sh && ./configure --prefix="$TMUX_OUTPUT" && make install

########## FINAL IMAGE ##########
FROM base-developer:$ALPINE_TAG
WORKDIR /projects

ARG DEV_USER
ARG DEV_UID
ARG DEV_GID

ARG STD_XDG_DATA_HOME=/home/$DEV_USER/.local/share
ARG STD_XDG_CONFIG_HOME=/home/$DEV_USER/.local/share

ENV ENV DEV_USER=$DEV_USER \
    DEV_UID=$DEV_UID \
    DEV_GID=$DEV_GID \
    XDG_CONFIG_HOME=$STD_XDG_CONFIG_HOME \
    XDG_DATA_HOME=$STD_XDG_DATA_HOME

COPY --from=tmux-build /tmux/tmux-install  /tmux
COPY --from=tmux-build /tmux/.tmux/.tmux.conf  $XDG_CONFIG_HOME/tmux/.tmux.conf
COPY --from=tmux-build /tmux/.tmux/.tmux.conf.local  $XDG_CONFIG_HOME/tmux/.tmux.conf.local
#COPY ./tmux/plugins.conf $XDG_CONFIG_HOME/tmux/plugins.conf

## TMUX binaries
RUN apk update && \
    apk add --no-cache \
    tmux \
## awk already exist in alpine, sed exist in base-developer, awk perl and sed required by .tmux.conf fetched from git
    perl \
## bash required by tmux-continuum plugin
    bash \
    openssh-server \
## configure ssh server
    openrc \
## Requeried for username to get populated through .tmux.conf.local (/bin/ps is replaced)
## see https://github.com/gpakosz/.tmux/issues/498
    procps

RUN mkdir -p $STD_XDG_CONFIG_HOME \
    && mkdir -p $STD_XDG_CONFIG_HOME \
    && mkdir -p /home/${DEV_USER}/.tmux/resurrect \
    && rm /usr/bin/tmux && ln -sf /tmux/bin/tmux /usr/bin/tmux \
## Symlink to the .tmux.conf fetched from git
    &&  ln -sf $XDG_CONFIG_HOME/tmux/.tmux.conf /home/${DEV_USER}/.tmux.conf \
# Copy the .tmux.conf.local fetched from git
    && cp $XDG_CONFIG_HOME/tmux/.tmux.conf.local /home/${DEV_USER}/.tmux.conf.local \
    && chown -R $DEV_USER:$DEV_USER /home/${DEV_USER} \
# Set permissions on WORKDIR /projects
    && chgrp -R ${DEV_USER} /projects \
    && chmod -R g=u /projects

# Adding known hosts: github
COPY ./nvim/.ssh /home/${DEV_USER}/.ssh

# Adding entrypoint script
COPY ./tmux/docker-entrypoint.sh /docker-entrypoint.sh

USER ${DEV_USER}

## Bash need to be set to 256 colors aswell to get correct fonts
## We also need to turn of flow control beacuse otherwise when pressing "Ctrl + a + d" it will detach from docker instead of detach from session
RUN echo "case \$TERM in xterm) TERM=xterm-256color;; esac" >> /$HOME/.bash_profile \
    && echo "export USERNAME=\$(whoami)" >> /$HOME/.bash_profile \
    && echo "stty -ixoff" > /$HOME/.profile

## tmux need to be set to 256 color and use the correct fonts
ENV TERM=xterm-256color \
    LC_ALL=en_US.UTF-8

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["tmux"]
