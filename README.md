# What is this image?

This image is a simple configuration of the [Nginx](https://nginx.org/en/) HTTP server, used for demonstrating the provision of a service from a container running on a Docker host.

# How to use this image

## Building container
```bash
docker build --build-arg HTTP_PROXY=$HTTP_PROXY --build-arg NO_PROXY=$NO_PROXY --build-arg VERSION=1.14.2 -t dimalegeza/nginxdemo-kubernetes .
```

## Running a container

### docker

The content and configuration of Nginx is simplistic, and can be invoked with:

```bash
docker container run --rm -d -p 80:80 dimalegeza/nginxdemo-kubernetes
```

### docker-compose
```bash
docker-compose up -d nginx
```
