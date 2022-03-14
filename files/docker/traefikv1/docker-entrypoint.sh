#!/bin/sh
set -e

# replace cluster definition (these vars is passed as env vars in ECS Task Definition)
sed -i "s/CLUSTER_HOST/$CLUSTER_HOST/;s/DOMAIN/$DOMAIN/" /etc/traefik/traefik.toml

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- traefik "$@"
fi

# if our command is a valid Traefik subcommand, let's invoke it through Traefik instead
# (this allows for "docker run traefik version", etc)
if traefik "$1" --help >/dev/null 2>&1
then
    set -- traefik "$@"
else
    echo "= '$1' is not a Traefik command: assuming shell execution." 1>&2
fi

exec "$@"
