# rider-developer

> Have only done some investigation.

## Linux: prerequisites

### For regular .NET or Mono applications

Install the latest stable Mono release from http://www.mono-project.com/download/.

### For .NET Core applications, install .NET Core for Linux

    apt-get update
    apt-get install -y
    apt-transport-https &
    apt-get update && apt-get > install -y dotnet-sdk-5.0

### Install Raider for linux

    wget https://download.jetbrains.com/rider/JetBrains.Rider-2021.1.3.tar.gz
    tar -xzf JetBrains.Rider-2021.1.3.tar.gz -C /opt
    cd opt/JetBrains\ Rider-2021.1.3/bin/
    ./rider.sh
