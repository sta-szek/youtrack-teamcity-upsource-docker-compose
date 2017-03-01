#!/usr/bin/env bash

JETBRAINS_USER_NAME=jetbrains
DIRS_TO_CREATE=(data logs temp backups)
JETBRAINS_USER_ID=2000

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
    if [ -d teamcity/${item} ]; then
        echo "directory teamcity/${item} already exist"
    else
        mkdir -v teamcity/${item}
    fi
done

chmod --recursive 770 teamcity
chown --changes --recursive ${JETBRAINS_USER_NAME}:pojo teamcity

#build docker
docker build --tag teamcity:latest \
             --force-rm \
             --file teamcity/Dockerfile \
             .

is_running=`docker top teamcity &>/dev/null`
if [ !${is_running} ]; then
    docker stop teamcity
fi

#run docker
docker run -p80:8111 \
           -v `pwd`/teamcity/data:/teamcity/data:rw \
           -v `pwd`/teamcity/logs:/teamcity/logs:rw \
           -v `pwd`/teamcity/temp:/teamcity/temp:rw \
           -v `pwd`/teamcity/backups:/teamcity/backups:rw \
           --name teamcity \
           --detach \
           --rm \
           teamcity