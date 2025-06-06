#
# Yocto run support for devel containers
#

if [ "$HOST_DEVICE_KVM" ]; then
	DEVICE_KVM="${HOST_DEVICE_KVM}"

	DOCKER_RUN_ARGS_ENV="$(run_docker_args_add "$DOCKER_RUN_ARGS_ENV" "--cap-add=SYS_ADMIN")"
	DOCKER_RUN_ARGS_ENV="$(run_docker_args_add "$DOCKER_RUN_ARGS_ENV" "--cap-add=SYS_RAWIO")"

	DOCKER_RUN_ARGS_MAP="$(run_docker_args_add "$DOCKER_RUN_ARGS_MAP" "-v $HOST_DEVICE_KVM:$DEVICE_KVM")"
fi

if [ "$HOST_DEVICE_LOOP" ]; then
	DEVICE_LOOP="${HOST_DEVICE_LOOP}"

	DOCKER_RUN_ARGS_ENV="$(run_docker_args_add "$DOCKER_RUN_ARGS_ENV" "--cap-add=SYS_ADMIN")"
	DOCKER_RUN_ARGS_ENV="$(run_docker_args_add "$DOCKER_RUN_ARGS_ENV" "--cap-add=SYS_RAWIO")"

	DOCKER_RUN_ARGS_MAP="$(run_docker_args_add "$DOCKER_RUN_ARGS_MAP" "-v $HOST_DEVICE_LOOP:$DEVICE_LOOP")"
fi

