FROM alpine:latest as build

# Define build argument for version
ARG VERSION=1.14.2
ARG HTTP_PROXY
ARG NO_PROXY

ENV HTTP_PROXY="$HTTP_PROXY"                                                                                           \
    http_proxy="$HTTP_PROXY"                                                                                           \
    HTTPS_PROXY="$HTTP_PROXY"                                                                                          \
    https_proxy="$HTTP_PROXY"                                                                                          \
    no_proxy="${NO_PROXY}"                                                                                             \
    NO_PROXY="${NO_PROXY}"

# Install build tools, libraries and utilities
RUN apk add --no-cache --virtual .build-deps                                                                           \
        build-base                                                                                                     \
        gnupg                                                                                                          \
        pcre-dev                                                                                                       \
        wget                                                                                                           \
        zlib-dev

# Retrieve, verify and unpack Nginx source
RUN set -x                                                                                                          && \
    cd "/tmp"                                                                                                       && \
    wget -q http://nginx.org/download/nginx-${VERSION}.tar.gz                                                       && \
    wget -q http://nginx.org/download/nginx-${VERSION}.tar.gz.asc                                                   && \
    tar -xf nginx-${VERSION}.tar.gz

WORKDIR /tmp/nginx-${VERSION}

# Build and install nginx
RUN ./configure                                                                                                        \
        --with-ld-opt="-static"                                                                                        \
        --with-http_sub_module                                                                                      && \
    make install                                                                                                    && \
    strip /usr/local/nginx/sbin/nginx

# Symlink access and error logs to /dev/stdout and /dev/stderr,
# in order to make use of Docker's logging mechanism
RUN ln -sf /dev/stdout /usr/local/nginx/logs/access.log                                                             && \
    ln -sf /dev/stderr /usr/local/nginx/logs/error.log

from scratch

# Customise static content, and configuration
COPY --from=build /usr/local/nginx /usr/local/nginx
# will not start without this line!! side effect of creating image from SCRATCH
COPY --from=build /etc/passwd /etc/group /etc/
COPY index.html /usr/local/nginx/html/
COPY nginx.conf /usr/local/nginx/conf/

# Change default stop signal from SIGTERM to SIGQUIT
STOPSIGNAL SIGQUIT

# Expose port
EXPOSE 80

# Define entrypoint and default parameters
ENTRYPOINT ["/usr/local/nginx/sbin/nginx"]
CMD ["-g", "daemon off;"]
