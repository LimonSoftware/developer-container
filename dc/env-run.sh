#
# Environment used by dc-run.sh to start devel container.
#
#   HOST_CONTAINER_NOT_PRIVILEGED: Set to know when container is not privileged, default 1 (optional).
#   HOST_STORAGE_DIR: The host storage dir to map (optional).
#   HOST_WORKSPACE_DIR: The host workspace dir to map, if isn't set handled by
#                       HOST_WORKSPACE_BASE_DIR.
#

set -eou pipefail

source env-common.sh

[ ! -S "$DOCKER_SOCK" ] && echo "ERROR: Docker socket ($DOCKER_SOCK) not found, please setup docker." && exit 1
[ ! -c "$DEVICE_TUN" ] && echo "ERROR: Device ($DEVICE_TUN) not found, please load tun module." && exit 1

HOST_CONTAINER_NOT_PRIVILEGED=${HOST_CONTAINER_NOT_PRIVILEGED:-1}
HOST_WORKSPACE_DIR="${HOST_WORKSPACE_DIR:-$HOST_WORKSPACE_BASE_DIR/$CONTAINER_NAME}"
mkdir -p "$HOST_WORKSPACE_DIR"

# Add argument if not find in the current args
run_docker_args_add() {
	args="$1"
	to_add="$2"
	append=${3:-1}

	if [ $append -eq 1 ]; then
		echo "$args" | grep -q -e "$to_add" || args="$args $to_add"
	fi

	echo "$args"
}

DOCKER_RUN_ARGS_ENV=" \
	$DOCKER_RUN_ARGS_ENV \
	-e HOSTNAME=$CONTAINER_NAME \
	-e HOST_WORKSPACE_DIR=$HOST_WORKSPACE_DIR \
"
DOCKER_RUN_ARGS_MAP=" \
	$DOCKER_RUN_ARGS_MAP \
	-v $HOST_WORKSPACE_DIR:$HOST_WORKSPACE_DIR \
	-v $DOCKER_SOCK:$DOCKER_SOCK \
"

if [ "${HOST_STORAGE_DIR}" ]; then
	mkdir -p "${HOST_STORAGE_DIR}"
	DOCKER_RUN_ARGS_ENV="$(run_docker_args_add "$DOCKER_RUN_ARGS_ENV" "-e HOST_STORAGE_DIR=$HOST_STORAGE_DIR")"
	DOCKER_RUN_ARGS_MAP="$(run_docker_args_add "$DOCKER_RUN_ARGS_MAP" "-v $HOST_STORAGE_DIR:$HOST_STORAGE_DIR")"
fi

DOCKER_RUN_ARGS_ENV="$(run_docker_args_add "$DOCKER_RUN_ARGS_ENV" "--cap-add=NET_ADMIN" $HOST_CONTAINER_NOT_PRIVILEGED)"
DOCKER_RUN_ARGS_MAP="$(run_docker_args_add "$DOCKER_RUN_ARGS_MAP" "--device $DEVICE_TUN:$DEVICE_TUN" $HOST_CONTAINER_NOT_PRIVILEGED)"

# Flavour support
env_host_load_flavour run
