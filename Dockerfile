FROM alpine:latest

# Define build argument for version
ARG VERSION
ARG HTTP_PROXY
ARG NO_PROXY

ENV HTTP_PROXY="$HTTP_PROXY"                                                                                           \
    http_proxy="$HTTP_PROXY"                                                                                           \
    HTTPS_PROXY="$HTTP_PROXY"                                                                                          \
    https_proxy="$HTTP_PROXY"                                                                                          \
    no_proxy="${NO_PROXY}"                                                                                             \
    NO_PROXY="${NO_PROXY}"

RUN set -x                                                                                                          && \
                                                                                                                       \
# Install build tools, libraries and utilities                                                                         \
    apk add --no-cache --virtual .build-deps                                                                           \
        build-base                                                                                                     \
        gnupg                                                                                                          \
        pcre-dev                                                                                                       \
        wget                                                                                                           \
        zlib-dev                                                                                                    && \
                                                                                                                       \
# Retrieve, verify and unpack Nginx source                                                                             \
    TMP="$(mktemp -d)" && cd "$TMP"                                                                                 && \
    wget -q http://nginx.org/download/nginx-${VERSION}.tar.gz                                                       && \
    wget -q http://nginx.org/download/nginx-${VERSION}.tar.gz.asc                                                   && \
    tar -xf nginx-${VERSION}.tar.gz                                                                                 && \
                                                                                                                       \
# Build and install nginx                                                                                              \
    cd nginx-${VERSION}                                                                                             && \
    ./configure                                                                                                        \
        --with-ld-opt="-static"                                                                                        \
        --with-http_sub_module                                                                                      && \
    make install                                                                                                    && \
    strip /usr/local/nginx/sbin/nginx                                                                               && \
                                                                                                                       \
# Clean up                                                                                                             \
    cd / && rm -rf "$TMP"                                                                                           && \
    apk del .build-deps                                                                                             && \
                                                                                                                       \
# Symlink access and error logs to /dev/stdout and /dev/stderr,                                                        \
# in order to make use of Docker's logging mechanism                                                                   \
    ln -sf /dev/stdout /usr/local/nginx/logs/access.log                                                             && \
    ln -sf /dev/stderr /usr/local/nginx/logs/error.log

# Customise static content, and configuration
COPY nginx.conf /usr/local/nginx/conf/

# Add entrypoint script
COPY docker-entrypoint.sh /

# Change default stop signal from SIGTERM to SIGQUIT
STOPSIGNAL SIGQUIT

# Expose port
EXPOSE 80

# Define entrypoint and default parameters
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
