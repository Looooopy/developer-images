# Run

Run a container utilizing `./run` script

This script incorperate the [.env file](/src/.env) so update it accoring your needs [More info env](./environment.md)

## Run Command

Syntax:

    developer-images>
    ./run -s [tmux or nvim] -v [latest or specific] -r [sh]

Sample:

> Run help

    developer-images>
    ./run

    Usage: ./run [-hrvs]
    ------------------------------------------------------------------------------------------------------------
    Switch             Args            Default   Description
    -h --help                                    Prints this usage screen
    -r --run-arg       [arg1]                    Argument should be passed to docker run
                                                    - Option can be specified multiple times
    -v --version       [arg1]          latest    Run version arg1=latest or specific
    -s --service       [arg1]                    Run service ( "base", "tmux", "nvim" )
    ------------------------------------------------------------------------------------------------------------

    Error: Required option --service

> Run tmux latest

    developer-images>
    ./run -s tmux

> Run tmux specific version and bypass start of tmux and just login to shell

    developer-images>
    ./run --service tmux --version specific --run-arg sh
