#!/bin/bash
#
# install.sh: Script to execute OS image customization at Dockerfile step
#

source env-build.sh

apt-get update
apt-get install -y ${DOCKER_OS_DEVEL_PKGS}
apt-get install -y ${DOCKER_OS_TOOLS_PKGS}
sh -c "${DOCKER_OS_TOOLS_CMD}"
