#!/bin/bash
# 
# Host setup expansion helper
#

source env-devel-environ.sh

step="$1"

env_host="env-host.sh"
if [ "$step" == "build" ]; then
	cp "$env_host.in" "$env_host"
	sed -i "s|__HOST_CONTAINER_FLAVOUR__|$HOST_CONTAINER_FLAVOUR|g" "$env_host"
	sed -i "s|__HOST_STORAGE_BASE_DIR__|$HOST_STORAGE_BASE_DIR|g" "$env_host"
	sed -i "s|__HOST_WORKSPACE_BASE_DIR__|$HOST_WORKSPACE_BASE_DIR|g" "$env_host"
	sed -i "s|__USER_UID__|$USER_UID|g" "$env_host"
	sed -i "s|__USER_GID__|$USER_GID|g" "$env_host"

	sed "s|__INIT_SCRIPT__|$INIT_SCRIPT|g" Dockerfile.in > Dockerfile
elif [ "$step" == "run" ]; then
	if [ ! -f "$env_host" ]; then
		echo "ERROR: $env_host file doesn't exist."
		echo "ERROR: Execute ./image-build.sh first."
		exit 1
	fi
else
	echo "ERROR: $0 invalid step $step"
	echo "Usage: $0 [build|run]"
	exit 1
fi
