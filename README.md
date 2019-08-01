# What is this image?

This image is a simple configuration of the [Nginx](https://nginx.org/en/) HTTP server, used for demonstrating the provision of a service from a container running on a Docker host.
What happens within Docker build:
* basing on Alpine latest;
* definition of proxies (if needed);
* installation of build tools needed;
* downloading of Nginx source
* symlinking Nginx logs to Docker IO streams to make use of Docker logging mechanism;
* addition of static content 
* defining entrypoint script
* expose of port 80 to outside world

# Branches
You can see two branches in this repo:
* **docker-build** standing for regular Docker build with all the best-practices in place
* **docker-multistage-build** that make use of Docker multistage build process (when you can define from that on FROM section in your Dockerfile)

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