# Netcoredbg

This is used for debugging dotnet application and dll's through command line interface (CLI)

## Debug nvim

### Enable vebose logging

You can enable more verbose logging on DAP

```nvim command
:lua require("dap").set_log_level('TRACE')
```

### Attach to running process

Start Service

- Open bash prompt #1

```bash
    # Need to set the environment in ASPNET
    export ASPNETCORE_ENVIRONMENT='Development'

    cd /path/to/your/service/

    # Build
    dotnet build

    # Switch folder to bin output folder
    cd bin/../Debug/

    # Run you service (using nohup to bea able to see the logs)
    dotnet {servicename}.dll
```

Attach debugger

```nvim
    in normal mode

    press: '<leader>dd' (start debugger)
    press: 2 (attach process)
    press the number that match your servicename
```

Trigger break point

- Open bash prompt #2

```bash
    # Open second terminal

    # Send a http request
    wget http://service-name:port/weatherforecast && rm weatherforecast
```

## Debug cli

HTTP endpoint example)

Start Service

- Open bash prompt #1

```bash
    # Need to set the environment in ASPNET
    export ASPNETCORE_ENVIRONMENT='Development'

    cd /path/to/your/service/

    # Build the service
    dotnet build

    # Switch folder to bin output folder
    cd bin/../Debug/

    # Run you service (using nohup to bea able to see the logs)
    dotnet {servicename}.dll &

    # List the pid you need to attach to
    ps -aux | grep {servicename}
```

Debugging

```bash
    # Run you netcoredbg
    netcoredbg --interpreter=cli

    # Load the dll to debug
    file {servicename}.dll

    # Set breakpoint at line 29
    break WeatherForecastController.cs:29

    # Attach to pid accuired from ps -aux ...
    attach {pid}
```

Trigger break point

- Open bash prompt #2

```bash
    # Open second terminal

    # Send a http request
    wget http://service-name:port/weatherforecast && rm weatherforecast
```
