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

########## dotnetsdks ##########
FROM toolchain as dotnetsdks
WORKDIR /tmp

ENV DOTNET_ROOT /tmp/dotnet
RUN mkdir -p "$DOTNET_ROOT"

# install dotnet 6
ENV DOTNET_FILE=dotnet-sdk-6.0.101-linux-musl-x64.tar.gz
RUN curl -L -O "https://download.visualstudio.microsoft.com/download/pr/bd94779d-c7c4-47fd-b80a-0088caa0afc6/40f115bbf4c068359e7a066fe0b03dbc/$DOTNET_FILE" && \
    tar zxf "$DOTNET_FILE" -C "$DOTNET_ROOT"

# install dotnet 5
ENV DOTNET_FILE=dotnet-sdk-5.0.404-linux-musl-x64.tar.gz
RUN curl -L -O "https://download.visualstudio.microsoft.com/download/pr/efedb4fc-acec-4d03-a502-3e1ecc51eb0a/f4ee529ee13dc95bcd9146ca07e9174e/$DOTNET_FILE" && \
    tar zxf "$DOTNET_FILE" -C "$DOTNET_ROOT"

# Install dotnet 3.1
ENV DOTNET_FILE=dotnet-sdk-3.1.416-linux-musl-x64.tar.gz
RUN curl -L -O "https://download.visualstudio.microsoft.com/download/pr/1da779d5-0177-4a0c-a439-34f38e1d4761/56649104a169e490e09b5cfc6e4ba26e/$DOTNET_FILE" && \
    tar zxf "$DOTNET_FILE" -C "$DOTNET_ROOT"

# Install dotnet 2.2
ENV DOTNET_FILE=dotnet-sdk-2.2.207-linux-musl-x64.tar.gz
RUN curl -L -O "https://download.visualstudio.microsoft.com/download/pr/c72122bd-38f5-4c98-b585-b8aaf57ecc6e/c89d7774a430e163d801753654f33972/$DOTNET_FILE" && \
    tar zxf "$DOTNET_FILE" -C "$DOTNET_ROOT"

# TDOD: Move this when DOTNET is moved somewhere else..
# To be able to build gRPC (Grpc.Tools)
RUN curl -L -O "https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub" && \
    curl -L -O "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk" 

# Azure Artifacts Credential Provider (Use for getting private nuget feeds)
RUN sh -c "$(curl -fsSL https://aka.ms/install-artifacts-credprovider.sh)" 
RUN mkdir -p /tmp/NuGet/plugins && mv "$HOME/.nuget/plugins/" /tmp/NuGet

########## netcoredbg-build ##########
FROM dotnetsdks as netcoredbg-build
WORKDIR /tmp

RUN apk update && apk add --no-cache \
        clang \
        icu-dev \
        linux-headers

ENV NETCOREDBG_VERSION=2.0.0-880
RUN curl -L -O "https://github.com/Samsung/netcoredbg/archive/refs/tags/$NETCOREDBG_VERSION.tar.gz" && \
    tar zxf "$NETCOREDBG_VERSION.tar.gz" && \
    cd "netcoredbg-$NETCOREDBG_VERSION" && \
    mkdir ./build && \
    cd build && \
    CC=clang CXX=clang++ cmake .. -DDOTNET_DIR=/tmp/dotnet -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PWD/../bin && \
    make && \
    make install


# ########## FINAL IMAGE ##########
FROM base-developer:$ALPINE_TAG as final-image
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
        icu-libs \
# Install docker-cli to let lspcontainers start containers from this image.
        docker-cli \
        socat \
# Install dependencies to make telescope faster
        ripgrep \
        fd

RUN wget https://github.com/wfxr/code-minimap/releases/download/v0.6.1/code-minimap-v0.6.1-x86_64-unknown-linux-musl.tar.gz \
         && tar -xzf code-minimap-v0.6.1-x86_64-unknown-linux-musl.tar.gz \
         && mv code-minimap-v0.6.1-x86_64-unknown-linux-musl/code-minimap /usr/bin/code-minimap

# Adding known hosts: github
COPY ./nvim/.ssh /home/${DEV_USER}/.ssh

# Adding entrypoint script
COPY ./nvim/docker-entrypoint.sh /docker-entrypoint.sh

# TDOD: Move DOTNET somewhere else..
########################################################################################################################################
## Prepare dotnet sdk folder
ENV DOTNET_ROOT /tmp/dotnet
ENV NETCOREDBG_ROOT=$DOTNET_ROOT/netcoredbg
ENV PATH "$PATH:$DOTNET_ROOT:$NETCOREDBG_ROOT"

# Don't send telementry to microsoft
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
# NUGET list all paths
#   CMD's:
#       dotnet nuget locals all --list
#       dotnet nuget locals all --clear
#       Note: https://docs.microsoft.com/en-us/nuget/Consume-Packages/managing-the-global-packages-and-cache-folders
ENV NUGET_PACKAGES=/projects/NuGet/packages
ENV NUGET_HTTP_CACHE_PATH=/projects/NuGet/v3-cache
ENV NUGET_PLUGINS_CACHE_PATH=/projects/NuGet/plugin-cache
ENV NUGET_PLUGIN_PATHS=/tmp/NuGet/plugins/netcore/CredentialProvider.Microsoft/CredentialProvider.Microsoft.dll

#ENV TMPDIR=/projects/tmp

#Run msbuild as dev_user
#dotnet clean /P:Username=dev_user
#dotnet build /P:Username=dev_user

COPY --from=dotnetsdks --chown=${DEV_USER}:${DEV_USER} "$DOTNET_ROOT/" "$DOTNET_ROOT"

# Abillity to build gRPC (Grpc.Tools)
COPY --from=dotnetsdks /tmp/glibc-2.34-r0.apk /tmp/glibc-2.34-r0.apk
COPY --from=dotnetsdks /tmp/sgerrand.rsa.pub /etc/apk/keys/sgerrand.rsa.pub
RUN apk add /tmp/glibc-2.34-r0.apk && rm /tmp/glibc-2.34-r0.apk


# Install Azure Artifacts Credential Provider (Use for getting private nuget feeds)
COPY --from=dotnetsdks --chown=${DEV_USER}:${DEV_USER} "/tmp/NuGet/plugins/" "/tmp/NuGet/plugins"


COPY --from=netcoredbg-build --chown=${DEV_USER}:${DEV_USER} \
    /tmp/netcoredbg-2.0.0-880/bin/netcoredbg \
    /tmp/netcoredbg-2.0.0-880/bin/libdbgshim.so \
    /tmp/netcoredbg-2.0.0-880/bin/ManagedPart.dll \
    /tmp/netcoredbg-2.0.0-880/bin/Microsoft.CodeAnalysis.dll \
    /tmp/netcoredbg-2.0.0-880/bin/Microsoft.CodeAnalysis.CSharp.dll \
    /tmp/netcoredbg-2.0.0-880/bin/Microsoft.CodeAnalysis.Scripting.dll \
    /tmp/netcoredbg-2.0.0-880/bin/Microsoft.CodeAnalysis.CSharp.Scripting.dll \
    /tmp/dotnet/netcoredbg/

COPY --chown=${DEV_USER}:${DEV_USER} ./nvim/msbuild/Custom.Before.Microsoft.Common.props $DOTNET_ROOT/sdk/6.0.101/Current/Custom.Before.Microsoft.Common.props
########################################################################################################################################

USER ${DEV_USER}

# Install dotnet-scripts (*.csx) (Install folder: $HOME/.dotnet/tools)
RUN dotnet tool install --global dotnet-script

# Dont move/remove this argument is here only to force rebuild plugins if all is cached
ARG FORCE_UPDATE_PLUGINS=no

# Install nvim plugins
COPY --chown=${DEV_USER}:${DEV_USER} ./nvim/init.vim $STD_XDG_CONFIG_HOME/nvim/init.vim
RUN nvim --headless +PlugInstall +qall

# Install tresitter languages
COPY --chown=${DEV_USER}:${DEV_USER} ./nvim/treesitter/ $STD_XDG_CONFIG_HOME/temp/treesitter
RUN bash -c "$XDG_CONFIG_HOME/temp/treesitter/install-langs.sh" &&\
    rm -R ${STD_XDG_CONFIG_HOME:?}/temp/

COPY --chown=${DEV_USER}:${DEV_USER} ./nvim/config/ $STD_XDG_CONFIG_HOME/nvim/config
COPY --chown=${DEV_USER}:${DEV_USER} ./nvim/lua/ $STD_XDG_CONFIG_HOME/nvim/lua/

ENV TERM=xterm-256color \
    LC_ALL=en_US.UTF-8

#USER root

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nvim"]
