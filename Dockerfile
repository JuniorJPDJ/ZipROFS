FROM        python:3.15.1-alpine@sha256:54448f67d7c31c39e5cdd3ea2d6382395ce142806c284425f8e897d78a0465b3

# renovate: datasource=repology depName=alpine_3_24/fuse versioning=loose
ARG         FUSE_VERSION="2.9.9-r7"

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
ENV         PYTHONUNBUFFERED=1

ENTRYPOINT  [ "python", "./ziprofs.py" ]
