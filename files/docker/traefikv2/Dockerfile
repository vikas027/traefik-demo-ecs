FROM traefik:v2.5.3

ENV AWS_DEFAULT_REGION='ap-southeast-2'

# Optional (helpful for troubleshooting)
RUN apk add --no-cache curl bind-tools aws-cli \
    && rm -rf /var/cache/apk/* \
    && aws --version

COPY ./files/docker/traefikv2/traefik_ecs.toml /etc/traefik/traefik.toml
COPY ./files/docker/traefikv2/traefik_confs /etc/traefik/confs

COPY ./files/docker/traefikv2/docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["traefik"]
