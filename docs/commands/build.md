# Build

Build images utilizing `./build` script

This script incorperate the [.env file](/src/.env) so update it accoring your needs [More info env](./environment.md)

## Build Command

Syntax:

    developer-images>
    ./build --version (-v)  [latest or specific] --services (-s) [base, tmux and/or nvim]

Sample:

> Build help

    developer-images>
    ./build

    Usage: ./build [-hnvsa]
    ------------------------------------------------------------------------------------------------------------
    Switch             Args            Default   Description
    -h --help                                    Prints this usage screen
    -n --no-cache                                Build without docker cache
    -f --force-plugins                           Rebuild part of image "plugins"
    -v --version       [arg1]          latest    Build version arg1=latest or specific
    -s --service       [arg1]                    Build services "base", "tmux", "nvim"
                                                    - Option can be specified multiple times
                                                    - Deplicates are removed from tail
                                                    - Order of options is the build order
    -a --all-services                            Build all service in following order "base", "tmux", "nvim"
    ------------------------------------------------------------------------------------------------------------

    Error: Required option --service or --all-services

> Build all images versions

    developer-images>
    ./build --all-services

> Build tmux and nvim latest and not base image (it still need to be present)

    developer-images>
    ./build --version latest --service tmux --service nvim

> Build base and tmux latest

    developer-images>
    ./build --version latest --service base --service tmux
