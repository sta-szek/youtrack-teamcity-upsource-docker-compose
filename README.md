docker-compose with multiple [JetBrains](https://www.jetbrains.com/) services:
* youtrack (issue tracker)
* teamcity (ci)
* upsource (code browser)
* hub (centralized auth)

STILL IN PROGRESS

TODO:
* own teamcity Dockerfile:
  - switch user to teamcity -- currently is root
  - download teamcity on your own
  - remove dir teamcity-version
* scale teamcity agents with different volumes
* configure nginx as proxy

NICE TO HAVE
* use lightweight docker base image (FROM)
* rethink directories permissions
* rethink user names / groups / gid / uid
* push images to docker-hub