#
# Environment used by image-run.sh to start devel container
#
# HOST_DEVICE_TUN: Networking tun device, default: '/dev/net/tun' (optional).
# HOST_DOCKER_SOCK: Docker socket, default: '/var/run/docker.sock' (optional).
#
# Workspaces has it's own directories based on:
#
# HOST_WORKSPACE_BASE_DIR: The workspace base dir to create workspaces,
#                          default: '$HOME/workspaces' (optional).
# HOST_STORAGE_DIR: The host storage dir to map, if isn't set handled by
#                   HOST_STORAGE_BASE_DIR.
# HOST_STORAGE_BASE_DIR: The storage base dir to share data,
#                          default: '$HOME/storage' (optional).
#

set -eou pipefail

HOST_DEVICE_TUN="${HOST_DEVICE_TUN:-/dev/net/tun}"
[ ! -c "$HOST_DEVICE_TUN" ] && echo "ERROR: Device ($HOST_DEVICE_TUN) not found, please load tun module." && exit 1
DEVICE_TUN="$HOST_DEVICE_TUN"

HOST_DOCKER_SOCK="${HOST_DOCKER_SOCK:-/var/run/docker.sock}"
[ ! -S "$HOST_DOCKER_SOCK" ] && echo "ERROR: Docker socket ($HOST_DOCKER_SOCK) not found, please setup docker." && exit 1
DOCKER_SOCK="$HOST_DOCKER_SOCK"

HOST_WORKSPACE_BASE_DIR="${HOST_WORKSPACE_BASE_DIR:-$HOME/workspaces}"
HOST_WORKSPACE_DIR="$HOST_WORKSPACE_BASE_DIR/$CONTAINER_NAME"
mkdir -p "$HOST_WORKSPACE_DIR"

HOST_STORAGE_DIR="${HOST_STORAGE_DIR:-}"
if [ -z "${HOST_STORAGE_DIR}" ]; then
	HOST_STORAGE_BASE_DIR="${HOST_STORAGE_BASE_DIR:-$HOME/storage}"
	HOST_STORAGE_DIR="$HOST_STORAGE_BASE_DIR/$CONTAINER_NAME"
	mkdir -p "$HOST_STORAGE_DIR"
fi

source env-common.sh

# Add argument if not find in the current args
run_docker_args_add() {
	args="$1"
	to_add="$2"
	echo "$args" | grep -q -e "$to_add" || args="$args $to_add"
	echo "$args"
}

DOCKER_RUN_ARGS_ENV=" \
	-e HOSTNAME=$CONTAINER_NAME \
"
DOCKER_RUN_ARGS_ENV="$(run_docker_args_add "$DOCKER_RUN_ARGS_ENV" "--cap-add=NET_ADMIN")"

DOCKER_RUN_ARGS_MAP=" \
	-v $HOST_DEVICE_TUN:$DEVICE_TUN \
	-v $HOST_DOCKER_SOCK:$DOCKER_SOCK \
	-v $HOST_WORKSPACE_DIR:$WORKSPACE_DIR \
	-v $HOST_STORAGE_DIR:$STORAGE_DIR \
"

# Load flavour customizations at build step
common_load_flavour run
