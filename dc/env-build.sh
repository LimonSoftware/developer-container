#
# Environment variables and functions.
#
# Docker base image packages to customize.
#
#  DOCKER_OS_DEVEL_PKGS: Devel components to install on image.
#  DOCKER_OS_TOOLS_PKGS: Tools to install on image, like docker.
#  DOCKER_OS_TOOLS_CMD: Extra commands to run for get tools packages.
#

set -eou pipefail

source env-common.sh

# Build

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
# Flavour support
env_host_load_flavour build
