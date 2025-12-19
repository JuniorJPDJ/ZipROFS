FROM        python:3.14.2-alpine@sha256:7af51ebeb83610fb69d633d5c61a2efb87efa4caf66b59862d624bb6ef788345

# renovate: datasource=repology depName=alpine_3_23/fuse versioning=loose
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
