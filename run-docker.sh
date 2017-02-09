#!/usr/bin/env bash

if [ -z "$1" ]
then
    echo "Pass unix username as first argument. This user will receive rights for newly created data folders."
    exit -1;
fi

JETBRAINS_PRODUCTS=(teamcity hub youtrack upsource)
JETBRAINS_USER_NAME=jetbrains
JETBRAINS_USER_ID=2000
CURRENT_USER_GID=$1
echo ${CURRENT_USER_GID}

groupadd --gid ${JETBRAINS_USER_ID} ${JETBRAINS_USER_NAME}
useradd --system --uid ${JETBRAINS_USER_ID} --gid ${JETBRAINS_USER_NAME} ${JETBRAINS_USER_NAME}

for item in ${JETBRAINS_PRODUCTS[*]}
do
    mkdir -vp ${item}/backups
    mkdir -v  ${item}/data
    mkdir -v  ${item}/log
    mkdir -v  ${item}/tmp
    mkdir -v  ${item}/conf
    chown --changes --recursive ${JETBRAINS_USER_NAME}:${CURRENT_USER_GID} ${item}
done

docker-compose up -d
