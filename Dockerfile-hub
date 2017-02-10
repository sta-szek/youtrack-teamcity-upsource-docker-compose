FROM openjdk:latest
MAINTAINER Piotr Joński <yoyo@wp.eu>

ARG HUB_VERSION=2017.1.4205
ARG USER_ID=2000
ARG USER_NAME=jetbrains
ARG BASE_URL=http://localhost/
ENV PORT=8080

RUN groupadd --gid ${USER_ID} ${USER_NAME} && \
    useradd --create-home --home-dir /hub --uid ${USER_ID} --gid ${USER_NAME} ${USER_NAME} && \
    chown --changes ${USER_NAME}:${USER_NAME} /hub

USER ${USER_NAME}
WORKDIR /hub

RUN mkdir backups data logs conf temp && \
    curl --location "https://download.jetbrains.com/hub/2017.1/hub-ring-bundle-${HUB_VERSION}.zip" > hub.zip && \
    unzip -q hub.zip && \
    rm -f hub.zip && \
    mv hub-ring-bundle-${HUB_VERSION}/* . && \
    rm -rf hub-ring-bundle-${HUB_VERSION} && \
    rm -rf internal/java/linux-x64/man && \
    rm -rf internal/java/mac-x64 && \
    rm -rf internal/java/windows-amd64

RUN bin/hub.sh configure \
    --backups-dir ${HOME}/backups \
    --data-dir    ${HOME}/data \
    --logs-dir    ${HOME}/logs \
    --temp-dir    ${HOME}/temp \
    --listen-port ${PORT} \
    --base-url    ${BASE_URL}

EXPOSE ${PORT}
CMD [ "/bin/bash", "/hub/bin/hub.sh", "run" ]
