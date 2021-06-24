# Neovim

Setup a docker container with all essential binaries to do some code editing.


## Build image

    docker build -t my-neovim:nightly .

## Run container

     docker run -v [your host projectfolder]:/projects -it --rm --name neowim my-neovim:nightly nvim .

     docker run -v ./projects:/projects -it --rm --name neowim my-neovim:nightly nvim .
