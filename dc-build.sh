#!/bin/bash
#
# Build wrapper of docker build
#
# Environment variables handled by host-setup.sh.
#
# Positional arguments:
#
# 1: Flavour load customization of container at env-common.sh.
#

DC_DIR="$(dirname "$(readlink -f "$0")")/dc" && cd "$DC_DIR"

HOST_CONTAINER_FLAVOUR="${1:-}"
export HOST_CONTAINER_FLAVOUR

HOST_STORAGE_DIR="${HOST_STORAGE_DIR:-}"
export HOST_STORAGE_DIR
HOST_WORKSPACE_BASE_DIR="${HOST_WORKSPACE_BASE_DIR:-$HOME/workspaces}"
export HOST_WORKSPACE_BASE_DIR
USER_UID="$(id -u)"
export USER_UID
USER_GID="$(id -g)"
export USER_GID

./host-setup.sh build || exit 1
source env-build.sh 

docker build \
	--build-arg DOCKER_OS_IMAGE="${DOCKER_OS_IMAGE}" \
	--build-arg DOCKER_OS_TAG="${DOCKER_OS_TAG}" \
	-t ${DOCKER_DEVEL_IMAGE}:${DOCKER_DEVEL_TAG} \
	.
