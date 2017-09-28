#!/bin/bash

docker stop teamcity-agent

sleep 5 

docker run -itd \
           -e SERVER_URL=http://ci.pojo.pl \
           -e AGENT_NAME=teamcity-agent \
           -v `pwd`/data/conf:/data/teamcity_agent/conf  \
           --name=teamcity-agent \
           --rm \
           jetbrains/teamcity-agent
