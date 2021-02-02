FROM openjdk:16-slim

WORKDIR /minecraft

RUN apt-get update && apt-get install -y wget jq curl

# Install rcon
RUN wget https://github.com/itzg/rcon-cli/releases/download/1.4.7/rcon-cli_1.4.7_linux_amd64.tar.gz && \
  tar -xzf rcon-cli_1.4.7_linux_amd64.tar.gz && \
  rm rcon-cli_1.4.7_linux_amd64.tar.gz && \
  mv rcon-cli /usr/local/bin

# Download the server
RUN MINECRAFT_VERSION=$(curl https://launchermeta.mojang.com/mc/game/version_manifest.json |jq '.latest.release') && \
#or uncomment to get specific version
    MINECRAFT_VERSION='"1.16.5"' && \
    versionmeta=$(curl https://launchermeta.mojang.com/mc/game/version_manifest.json |jq '.versions[] |select (.id == '"$MINECRAFT_VERSION"') |.url' | tr -d '"') && \
    serverjar=$(curl $versionmeta |jq '.downloads.server.url' |tr -d '"') && \
    wget $serverjar

# Copy the signed eula
COPY ./eula.txt eula.txt

# Add the entrypoint
COPY ./entrypoint.sh /minecraft/entrypoint.sh
COPY ./server.properties /server.properties

# Set defaults for environment variables
ENV MINECRAFT_PORT 25565
ENV RCON_PORT 27015
ENV JAVA_MEMORY 2G
ENV RCON_ENABLED true
ENV WHITELIST_ENABLED true
ENV ALLOW_NETHER true
ENV MAX_PLAYERS 20
ENV ENABLE_PVP true

ENTRYPOINT [ "/minecraft/entrypoint.sh" ]
