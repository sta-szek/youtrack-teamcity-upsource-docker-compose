FROM openjdk:latest
MAINTAINER Piotr Joński <p.jonski@pojo.pl>

ARG YOUTRACK_VERSION=2017.1.31260
ARG USER_ID=2000
ARG USER_NAME=jetbrains
ARG BASE_URL=http://localhost/
ENV PORT=8080

RUN groupadd --gid ${USER_ID} ${USER_NAME} && \
    useradd --create-home --home-dir /youtrack --uid ${USER_ID} --gid ${USER_NAME} ${USER_NAME} && \
    chown --changes ${USER_NAME}:${USER_NAME} /youtrack

USER ${USER_NAME}
WORKDIR /youtrack

RUN mkdir backups data logs conf temp && \
    curl --location "https://download.jetbrains.com/charisma/youtrack-${YOUTRACK_VERSION}.zip" > youtrack.zip && \
    unzip -q youtrack.zip && \
    rm -f youtrack.zip && \
    mv youtrack-${YOUTRACK_VERSION}/* . && \
    rm -rf youtrack-${YOUTRACK_VERSION} && \
    rm -rf internal/java/linux-x64/man && \
    rm -rf internal/java/mac-x64 && \
    rm -rf internal/java/windows-amd64

RUN bin/youtrack.sh configure \
    --backups-dir ${HOME}/backups \
    --data-dir    ${HOME}/data \
    --logs-dir    ${HOME}/logs \
    --temp-dir    ${HOME}/temp \
    --listen-port ${PORT} \
    --base-url    ${BASE_URL}

EXPOSE ${PORT}
CMD [ "/bin/bash", "/youtrack/bin/youtrack.sh", "run", "--no-browser" ]
