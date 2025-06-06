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

HOST_CONTAINER_FLAVOUR="${1:-}"
export HOST_CONTAINER_FLAVOUR

HOST_STORAGE_BASE_DIR="${HOST_STORAGE_BASE_DIR:-$HOME/storage}"
export HOST_STORAGE_BASE_DIR
HOST_WORKSPACE_BASE_DIR="${HOST_WORKSPACE_BASE_DIR:-$HOME/workspaces}"
export HOST_WORKSPACE_BASE_DIR
USER_UID="$(id -u)"
export USER_UID
USER_GID="$(id -g)"
export USER_GID

cd image && ./host-setup.sh build

HOST_STORAGE_DIR="${HOST_STORAGE_DIR:-$HOME/storage}"
source env-build.sh 
docker build \
	--build-arg DOCKER_OS_IMAGE="${DOCKER_OS_IMAGE}" \
	--build-arg DOCKER_OS_TAG="${DOCKER_OS_TAG}" \
	-t ${DOCKER_DEVEL_IMAGE}:${DOCKER_DEVEL_TAG} \
	.
