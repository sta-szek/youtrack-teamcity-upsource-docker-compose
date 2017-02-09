#!/usr/bin/env bash

if [ -z "$1" ]
then
    echo "Pass unix group name as first argument. This group will receive rights for data folders."
    exit -1;
fi

JETBRAINS_PRODUCTS=(teamcity hub youtrack upsource)
JETBRAINS_USER_NAME=jetbrains
JETBRAINS_USER_ID=2000
GROUP_NAME=$1
echo ${GROUP_NAME}

groupadd --gid ${JETBRAINS_USER_ID} ${JETBRAINS_USER_NAME}
useradd --system --uid ${JETBRAINS_USER_ID} --gid ${JETBRAINS_USER_NAME} ${JETBRAINS_USER_NAME}

for item in ${JETBRAINS_PRODUCTS[*]}
do
    mkdir -v  ${item}/backups
    mkdir -v  ${item}/data
    mkdir -v  ${item}/log
    mkdir -v  ${item}/tmp
    mkdir -v  ${item}/conf
    chown --changes --recursive ${JETBRAINS_USER_NAME}:${GROUP_NAME} ${item}
    chmod --recursive 770 ${item}
done

docker-compose up -d
