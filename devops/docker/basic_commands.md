# Docker basic commands

List containers
```
docker ps
```
Build an image from a Dockerfile
```
docker build
```
Dockerfile
```
FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install -y curl
```
