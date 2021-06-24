FROM alpine:latest as build

WORKDIR /neovim

# Install build depedencies and cloning repo checkout tag
RUN apk update && \
    apk add --no-cache \
	git \
	build-base \
	cmake \
	automake \
	autoconf \
	libtool \
	pkgconf \
	coreutils \
	curl \
	unzip \
	gettext-tiny-dev && \
    git clone https://github.com/neovim/neovim.git . && \
    git checkout nightly

RUN make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=/neovim/nvim-install" install


ENV XDG_CONFIG_HOME=/root/.local/share
RUN curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

FROM alpine:latest

WORKDIR /projects

ENV XDG_CONFIG_HOME=/root/.local/share
COPY --from=build /neovim/nvim-install  /neovim
COPY --from=build /root/.local/share $XDG_CONFIG_HOME
COPY ./init.vim /root/.local/share/nvim/

RUN apk update && \
    apk add neovim curl git --no-cache && \
    rm /usr/bin/nvim && ln -s /neovim/bin/nvim /usr/bin/nvim && \
    rm -r /usr/share/nvim && ln -s /neovim/share /usr/share/nvim && \
    ln -s /neovim/lib/parser/c.so /usr/lib/c.so

RUN nvim --headless +PlugInstall +qall

