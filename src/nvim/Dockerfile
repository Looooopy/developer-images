ARG ALPINE_TAG=latest
########## toolchain ##########
FROM base-developer:$ALPINE_TAG as toolchain

RUN apk update && \
    apk add --no-cache \
    git \
    build-base \
    cmake \
    automake \
    autoconf \
    pkgconfig \
    libtool \
    coreutils \
    curl \
    unzip \
    gettext-tiny-dev

########## neovim-build ##########
FROM toolchain as neovim-build
WORKDIR /neovim

ARG DEV_USER
ARG DEV_UID
ARG DEV_GID

ENV USER=$DEV_USER \
    UID=${DEV_UID} \
    GID=${DEV_GID} \
    USERNAME=$DEV_USER

ARG STD_XDG_DATA_HOME=/home/$DEV_USER/.local/share
ARG STD_XDG_CONFIG_HOME=/home/$DEV_USER/.local/share

ARG NEOVIM_OUTPUT_DIR=/neovim/nvim-install
ARG NEOVIM_GIT_BRANCH=nightly
ARG NEOVIM_XDG_DATA_HOME=$STD_XDG_DATA_HOME
ARG NEOVIM_XDG_CONFIG_HOME=$STD_XDG_CONFIG_HOME

ENV XDG_DATA_HOME=$NEOVIM_XDG_DATA_HOME
ENV XDG_CONFIG_HOME=$NEOVIM_XDG_CONFIG_HOME

RUN git clone https://github.com/neovim/neovim.git --branch "${NEOVIM_GIT_BRANCH:?}" .
RUN make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$NEOVIM_OUTPUT_DIR" install

########## FINAL IMAGE ##########
FROM base-developer:$ALPINE_TAG
WORKDIR /projects

ARG DEV_USER
ARG DEV_UID
ARG DEV_GID

ARG STD_XDG_DATA_HOME=/home/$DEV_USER/.local/share
ARG STD_XDG_CONFIG_HOME=/home/$DEV_USER/.local/share

ENV DEV_USER=$DEV_USER \
    DEV_UID=$DEV_UID \
    DEV_GID=$DEV_GID \
    XDG_CONFIG_HOME=$STD_XDG_CONFIG_HOME \
    XDG_DATA_HOME=$STD_XDG_DATA_HOME

COPY --from=neovim-build /neovim/nvim-install /neovim

# Install plugin manager for vim
RUN curl -fLo "${STD_XDG_DATA_HOME:?}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# nvim: Install and update the binary we built
RUN apk update && \
    apk add --no-cache \
        neovim && \
    rm /usr/bin/nvim && ln -s /neovim/bin/nvim /usr/bin/nvim && \
    rm -r /usr/share/nvim && ln -s /neovim/share /usr/share/nvim && \
    ln -s /neovim/lib/parser/c.so /usr/lib/c.so

# Fix permissions for ${STD_XDG_DATA_HOME:?}/nvim and /projects
RUN chgrp -R ${DEV_USER} ${STD_XDG_DATA_HOME:?}/nvim \
    && chmod -R g=u ${STD_XDG_DATA_HOME:?}/nvim \
    && chgrp -R ${DEV_USER} /projects \
    && chmod -R g=u /projects

# nvim-treesitter prereq's gcc g++ libstdc++ (git)
RUN apk add --no-cache \
        gcc \
        libstdc++ \
        g++ \
# Install docker-cli to let lspcontainers start containers from this image.
        docker-cli

# Adding known hosts: github
COPY ./nvim/.ssh /home/${DEV_USER}/.ssh

USER ${DEV_USER}

# Install nvim plugins
COPY --chown=${DEV_USER}:${DEV_USER} ./nvim/init.vim $STD_XDG_CONFIG_HOME/nvim/init.vim
RUN nvim --headless +PlugInstall +qall

# Install tresitter languages
COPY --chown=${DEV_USER}:${DEV_USER} ./nvim/treesitter/ $STD_XDG_CONFIG_HOME/temp/treesitter
RUN bash -c "$XDG_CONFIG_HOME/temp/treesitter/install-langs.sh"
RUN rm -R ${STD_XDG_CONFIG_HOME:?}/temp/

COPY --chown=${DEV_USER}:${DEV_USER} ./nvim/config/ $STD_XDG_CONFIG_HOME/nvim/config

ENV TERM=xterm-256color \
    LC_ALL=en_US.UTF-8

CMD ["nvim","/projects"]
