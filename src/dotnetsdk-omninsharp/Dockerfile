FROM debian:bullseye-slim

WORKDIR /tmp

RUN apt update && apt upgrade -y && \
    apt install curl htop -y && \
    rm -rf /var/lib/apt/lists && \
    curl -L -O https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v1.38.0/omnisharp-linux-x64.tar.gz  && \
    tar -xf omnisharp-linux-x64.tar.gz -C /usr && \
    rm omnisharp-linux-x64.tar.gz

# mono dependencies
#RUN apt install dirmngr gnupg apt-transport-https -y \
# RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
#     sh -c 'echo "deb https://download.mono-project.com/repo/debian stable-buster main" > /etc/apt/sources.list.d/mono-official-stable.list'
# RUN apt update && apt install mono-complete -y

ENV DOTNET_ROOT /tmp/dotnet
ENV PATH "$PATH:$DOTNET_ROOT"
RUN mkdir -p "$DOTNET_ROOT"

# Install dotnet 6.0.101
ENV DOTNET_FILE=dotnet-sdk-6.0.101-linux-x64.tar.gz
RUN curl -L -O "https://download.visualstudio.microsoft.com/download/pr/ede8a287-3d61-4988-a356-32ff9129079e/bdb47b6b510ed0c4f0b132f7f4ad9d5a/$DOTNET_FILE"
RUN tar zxf "$DOTNET_FILE" -C "$DOTNET_ROOT"

# Install dotnet 5.0.404
ENV DOTNET_FILE=dotnet-sdk-5.0.404-linux-x64.tar.gz
RUN curl -L -O "https://download.visualstudio.microsoft.com/download/pr/2c1eb8c8-ac05-4dc7-9bef-307b3e450e9d/75e85b3d1662f60afd69572fd5df6884/$DOTNET_FILE"
RUN tar zxf "$DOTNET_FILE" -C "$DOTNET_ROOT"

# Install dotnet 3.1.416
ENV DOTNET_FILE=dotnet-sdk-3.1.416-linux-x64.tar.gz
RUN curl -L -O "https://download.visualstudio.microsoft.com/download/pr/3c98126b-50f5-4497-8ffd-18d17a3f6b95/044d0f20256fd9bf2971f8da9a0364e4/$DOTNET_FILE"
RUN tar zxf "$DOTNET_FILE" -C "$DOTNET_ROOT"

# Install dotnet 2.2.207
ENV DOTNET_FILE=dotnet-sdk-2.2.207-linux-x64.tar.gz
RUN curl -L -O "https://download.visualstudio.microsoft.com/download/pr/022d9abf-35f0-4fd5-8d1c-86056df76e89/477f1ebb70f314054129a9f51e9ec8ec/$DOTNET_FILE"
RUN tar zxf "$DOTNET_FILE" -C "$DOTNET_ROOT"

# Remove all gz files
RUN rm /tmp/*.gz*

# Set globalization to invariant so we dont need to install globilization in linux
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
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
#ENV TMPDIR=/projects/tmp

CMD [ "/usr/run", "--languageserver" ]