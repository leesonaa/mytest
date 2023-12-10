# !!! Don't try to build this Dockerfile directly, run it through bin/build-docker.sh script !!!
FROM node:18.18.2-alpine
ADD trilium-linux-x64-server /app
# Create app directory
WORKDIR /app
# Install app dependencies
RUN set -x \
    && apk add --no-cache --virtual  autoconf \
        automake \
        g++ \
        gcc \
        libtool \
        make \
        nasm \
        libpng-dev \
        python3 \
    && npm install \
    && apk del .build-dependencies \
    && npm prune --omit=dev \
# Some setup tools need to be kept
# RUN apk add --no-cache su-exec shadow

# Add application user and setup proper volume permissions
# RUN adduser -s /bin/false node; exit 0

# Start the application
EXPOSE 8080
CMD node /app/src/www

