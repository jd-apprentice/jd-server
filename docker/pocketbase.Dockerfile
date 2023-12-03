FROM balenalib/armv7hf-alpine:3.13-build

RUN apk add --no-cache \
    wget=1.21.1-r1 \
    unzip=6.0-r9 \
    && rm -rf /var/cache/apk/*

RUN wget https://github.com/pocketbase/pocketbase/releases/download/v0.19.4/pocketbase_0.19.4_linux_armv7.zip
RUN unzip pocketbase_0.19.4_linux_armv7.zip
RUN mv pocketbase /usr/local/bin/pocketbase

EXPOSE 8090

HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost/ || exit 1

ENTRYPOINT ["/usr/local/bin/pocketbase"]