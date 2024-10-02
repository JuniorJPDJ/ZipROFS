FROM        python:3.12.7-alpine@sha256:e75de178bc15e72f3f16bf75a6b484e33d39a456f03fc771a2b3abb9146b75f8

# renovate: datasource=repology depName=alpine_3_20/fuse versioning=loose
ARG         FUSE_VERSION="2.9.9-r5"

ARG         TARGETPLATFORM

WORKDIR     /app

ADD         requirements.txt .

RUN         --mount=type=cache,sharing=locked,target=/root/.cache,id=home-cache-$TARGETPLATFORM \
            apk add --no-cache \
              fuse=${FUSE_VERSION} \
            && \
            sed -i 's/#user_allow_other/user_allow_other/g' /etc/fuse.conf && \
            pip install -r requirements.txt && \
            chown -R nobody:nogroup /app

COPY        --chown=nobody:nogroup . .

USER        nobody
ENV         FUSE_LIBRARY_PATH=/usr/lib/libfuse.so.2

ENTRYPOINT  [ "python", "./ziprofs.py" ]
