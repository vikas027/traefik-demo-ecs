FROM traefik:v1.7.24-alpine

ENV AWS_DEFAULT_REGION='ap-southeast-2'

# Optional (helpfule for troubleshooting)
RUN apk update && \
    apk add --no-cache curl bind-tools \
    python python-dev py-pip build-base \
    && pip install awscli==1.17.2 --upgrade --user \
    && apk --purge -v del py-pip \
    && rm -rf /var/cache/apk/* \
    && ln -s /root/.local/bin/aws /usr/local/bin/

COPY ./files/docker/traefik/traefik_ecs.toml /etc/traefik/traefik.toml

COPY ./files/docker/traefik/docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
