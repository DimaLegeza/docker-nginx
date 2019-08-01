# What is this image?

This image is a simple configuration of the [Nginx](https://nginx.org/en/) HTTP server, used for demonstrating the provision of a service from a container running on a Docker host, or from containers deployed as service tasks in a Swarm cluster.

# How to use this image

## Building container
```
docker build --build-arg HTTP_PROXY=$HTTP_PROXY --build-arg NO_PROXY=$NO_PROXY --build-arg VERSION=1.14.2 -t dimalegeza/nginxdemo .
```

## Running a container

The content and configuration of Nginx is simplistic, and can be invoked with:

```
$ docker container run --rm -d -p 80:80 dimalegeza/nginxdemo
```