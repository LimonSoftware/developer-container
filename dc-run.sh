#!/bin/bash
#
# dc-run.sh: Developer container runner wrapper.
#
# Positional arguments:
#
# 1: Container name, required.
# 2: Flavour load customization of container at env-common.sh.
#
# Environment
# 	DEVEL_CONTAINER_AUTOSTART: Auto start after OS, default 1 (optional).
# 	DEVEL_CONTAINER_PRIVILEDGED: Allow access to the host resources from container, default 0 (optional).
# 	DEVEL_CONTAINER_USER_CONTEXT: Enable current user context, details below, default 1 (optional).
#
# Starts docker container using pre-built devel image.
#

DEVEL_CONTAINER_AUTOSTART=${DEVEL_CONTAINER_AUTOSTART:-1}
DEVEL_CONTAINER_PRIVILEDGED="${DEVEL_CONTAINER_PRIVILEDGED:-0}"
DEVEL_CONTAINER_USER_CONTEXT=${DEVEL_CONTAINER_USER_CONTEXT:-1}

if [ -z "${1:-}" ]; then
	echo "Usage: $0 <workspace_name>"
	exit 1
fi
CONTAINER_NAME="$1"

HOST_CONTAINER_FLAVOUR="${2:-}"
export HOST_CONTAINER_FLAVOUR

cd dc && ./host-setup.sh run || exit 1
source env-run.sh

# Docker base arguments
DOCKER_ARGS=" \
	--name $CONTAINER_NAME \
	--hostname $CONTAINER_NAME \
	-d \
"
[ $DEVEL_CONTAINER_AUTOSTART -eq 1 ] && DOCKER_ARGS="$DOCKER_ARGS --restart unless-stopped"

# Allow access to /dev and add priviledged.
if [ $DEVEL_CONTAINER_PRIVILEDGED -eq 1 ]; then 
	DOCKER_ARGS="$DOCKER_ARGS --privileged"
	DOCKER_RUN_ARGS_MAP="$DOCKER_RUN_ARGS_MAP -v /dev:/dev"
fi

# Allow access to host user HOME and SSH_AUTH
if [ $DEVEL_CONTAINER_USER_CONTEXT -eq 1 ]; then
	DOCKER_RUN_ARGS_MAP="$(run_docker_args_add "$DOCKER_RUN_ARGS_MAP" "-v $HOME:$HOME")"

	# Add SSH Auth if variable is set
	if [ "${SSH_AUTH_SOCK:-}" ]; then
		DOCKER_RUN_ARGS_ENV="$(run_docker_args_add "$DOCKER_RUN_ARGS_ENV" "-e SSH_AUTH_SOCK=$SSH_AUTH_SOCK")"
		DOCKER_RUN_ARGS_MAP="$(run_docker_args_add "$DOCKER_RUN_ARGS_MAP" "-v $SSH_AUTH_SOCK:$SSH_AUTH_SOCK")"
	fi
fi

# If container exists rename to old prefix
# and inform the user.
if [ "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]; then
	container_rename="devel-old-review"

	echo "Warning: Container $CONTAINER_NAME already exists"
	echo "Renaming $CONTAINER_NAME to $container_rename"
	docker stop "$CONTAINER_NAME"
	docker rename "$CONTAINER_NAME" "$container_rename"
	docker update --restart=no "$container_rename"
	echo ""
fi

echo "Running container $CONTAINER_NAME ..."
docker run $DOCKER_ARGS \
	   $DOCKER_RUN_ARGS_ENV \
	   $DOCKER_RUN_ARGS_MAP \
	   $DOCKER_DEVEL_IMAGE:$DOCKER_DEVEL_TAG
