#!/bin/bash
#
# Build wrapper of docker build
#
# Positional arguments:
#
# 1: Flavour load customization of container at env-common.sh.
#

DEVEL_CONTAINER_FLAVOUR="${1:-}"

cd image && source env-build.sh

sed "s|__INIT_SCRIPT__|${INIT_SCRIPT}|g" Dockerfile.in > Dockerfile
docker build \
	--build-arg DEVEL_CONTAINER_FLAVOUR="$DEVEL_CONTAINER_FLAVOUR" \
	--build-arg DOCKER_OS_IMAGE="${DOCKER_OS_IMAGE}" \
	--build-arg DOCKER_OS_TAG="${DOCKER_OS_TAG}" \
	--build-arg USER_UID="$(id -u)" \
	--build-arg USER_GID="$(id -g)" \
	-t ${DOCKER_DEVEL_IMAGE}:${DOCKER_DEVEL_TAG} \
	.
