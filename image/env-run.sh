#
# Environment used by image-run.sh to start devel container
#
# HOST_STORAGE_DIR: The host storage dir to map (optional).
# HOST_WORKSPACE_DIR: The host workspace dir to map, if isn't set handled by
#                   HOST_WORKSPACE_BASE_DIR.
#

set -eou pipefail

source env-common.sh

[ ! -S "$HOST_DOCKER_SOCK" ] && echo "ERROR: Docker socket ($HOST_DOCKER_SOCK) not found, please setup docker." && exit 1
[ ! -c "$HOST_DEVICE_TUN" ] && echo "ERROR: Device ($HOST_DEVICE_TUN) not found, please load tun module." && exit 1

HOST_WORKSPACE_DIR="${HOST_WORKSPACE_DIR:-$HOST_WORKSPACE_BASE_DIR/$CONTAINER_NAME}"
mkdir -p "$HOST_WORKSPACE_DIR"

# Add argument if not find in the current args
run_docker_args_add() {
	args="$1"
	to_add="$2"
	echo "$args" | grep -q -e "$to_add" || args="$args $to_add"
	echo "$args"
}

DOCKER_RUN_ARGS_ENV=" \
	-e HOSTNAME=$CONTAINER_NAME \
	-e HOST_WORKSPACE_DIR=$HOST_WORKSPACE_DIR \
"
DOCKER_RUN_ARGS_ENV="$(run_docker_args_add "$DOCKER_RUN_ARGS_ENV" "--cap-add=NET_ADMIN")"

DOCKER_RUN_ARGS_MAP=" \
	-v $HOST_DEVICE_TUN:$DEVICE_TUN \
	-v $HOST_DOCKER_SOCK:$DOCKER_SOCK \
	-v $HOST_WORKSPACE_DIR:$HOST_WORKSPACE_DIR \
"

if [ "${HOST_STORAGE_DIR}" ]; then
	mkdir -p "${HOST_STORAGE_DIR}"
	DOCKER_RUN_ARGS_ENV="$(run_docker_args_add "$DOCKER_RUN_ARGS_ENV" "-e HOST_STORAGE_DIR=$HOST_STORAGE_DIR")"
	DOCKER_RUN_ARGS_MAP="$(run_docker_args_add "$DOCKER_RUN_ARGS_MAP" "-v $HOST_STORAGE_DIR:$HOST_STORAGE_DIR")"
fi

# Load flavour customizations at build step
common_load_flavour run
