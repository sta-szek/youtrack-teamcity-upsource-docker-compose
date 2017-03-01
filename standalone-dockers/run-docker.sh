#!/usr/bin/env bash

SERVICE_NAME=$1
JETBRAINS_USER_NAME=jetbrains
DIRS_TO_CREATE=(backups data logs temp conf)
JETBRAINS_USER_ID=2000
PORT=8080

if [ -z ${SERVICE_NAME} ]; then
    echo "pass service name to create as first argument. e.g. hub"
    exit 0;
fi

if [ ${SERVICE_NAME} = "teamcity" ]; then
    echo "changing internal port to 8111 - only for teamcity"
    PORT=8111
fi

# create user if not exist
if [ $(getent passwd ${JETBRAINS_USER_NAME}) ]; then
    echo "user ${JETBRAINS_USER_NAME} already exists"
else
    echo "creating user ${JETBRAINS_USER_NAME}"
    groupadd --gid ${JETBRAINS_USER_ID} ${JETBRAINS_USER_NAME}
    useradd --system --uid ${JETBRAINS_USER_ID} --gid ${JETBRAINS_USER_NAME} ${JETBRAINS_USER_NAME}
fi

# create directories if not exist
for item in ${DIRS_TO_CREATE[*]}
do
    if [ -d ${SERVICE_NAME}/${item} ]; then
        echo "directory ${SERVICE_NAME}/${item} already exist"
    else
        mkdir -v ${SERVICE_NAME}/${item}
    fi
done

chmod --recursive 770 ${SERVICE_NAME}
chown --changes --recursive ${JETBRAINS_USER_NAME}:pojo ${SERVICE_NAME}

#build docker
docker build --tag ${SERVICE_NAME}:latest \
             --force-rm \
             --file ${SERVICE_NAME}/Dockerfile \
             .

is_running=`docker top ${SERVICE_NAME} &>/dev/null`
if [ !${is_running} ]; then
    docker stop ${SERVICE_NAME}
    sleep 5
fi

#run docker
docker run -p80:${PORT} \
           -v `pwd`/${SERVICE_NAME}/backups:/${SERVICE_NAME}/backups:rw \
           -v `pwd`/${SERVICE_NAME}/data:/${SERVICE_NAME}/data:rw \
           -v `pwd`/${SERVICE_NAME}/logs:/${SERVICE_NAME}/logs:rw \
           -v `pwd`/${SERVICE_NAME}/conf:/${SERVICE_NAME}/conf:rw \
           -v `pwd`/${SERVICE_NAME}/temp:/${SERVICE_NAME}/temp:rw \
           --name ${SERVICE_NAME} \
           --detach \
           --rm \
           ${SERVICE_NAME}