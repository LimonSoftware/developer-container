#
# Environment variables and functions
#
# Base Image
#
# DOCKER_OS_DEVEL_PKGS: Devel components to install on image.
# DOCKER_OS_TOOLS_PKGS: Tools to install on image, like docker.
# DOCKER_OS_TOOLS_CMD: Extra commands to run for get tools packages.
#
# Setup Image
#
# DEFAULT_DEVEL_ENVIRON_FILE: Environment filename to install at /etc/default.
# INIT_SCRIPT:  Initialization script of the container to setup services.
#
# Setup Image - Users
#
# User details to create account inside container.
#
# USER_NAME
# USER_GROUP
# USER_UID
# USER_GID
# USER_GROUPS
# USER_SHELL
#

set -eou pipefail

source env-common.sh

# Build

## Docker OS image tag (base)
DOCKER_OS_IMAGE="${DOCKER_OS_IMAGE:-debian}"
DOCKER_OS_TAG="${DOCKER_OS_TAG:-stable}"

## Docker OS image customizations
DOCKER_OS_DEVEL_PKGS=" \
	bash-completion \
	build-essential \
	ca-certificates \
	curl \
	git \
	git-crypt \
	git-lfs \
	htop \
	iproute2 \
	less \
	net-tools \
	procps \
	strace \
	sudo \
	tmux \
	vim
"
DOCKER_OS_TOOLS_PKGS=" \
	docker.io \
	tinyproxy \
"

DOCKER_OS_TOOLS_CMD=" \
	curl -fsSL https://tailscale.com/install.sh | sh \
"
# Setup

## Environment and start/init
DEFAULT_DEVEL_ENVIRON_FILE="/etc/default/devel-environ"
INIT_SCRIPT="/usr/local/sbin/start_devel_environ.sh"

## User setup
USER_NAME="devel"
USER_GROUP="$USER_NAME"
USER_UID="__USER_UID__"
USER_GID="__USER_GID__"
USER_GROUPS="docker,sudo,users"
USER_SHELL="/bin/bash"
