#
# Common environment across env-{build,run}.sh
#
# Image Output
#
# DOCKER_DEVEL_IMAGE: Output image name
# DOCKER_DEVEL_TAG: Output image tag
#

source env-host.sh
source env-devel-environ.sh

common_load_flavour() {
	local type="$1"

	if [ "$HOST_CONTAINER_FLAVOUR" ]; then
		include_flavour="flavours/$HOST_CONTAINER_FLAVOUR-$type.sh"
		if [ ! -f "$include_flavour" ]; then
			echo "ERROR: Flavour ($HOST_CONTAINER_FLAVOUR) not supported"
			echo "ERROR: Loading flavour file ($include_flavour)"
			exit 1
		fi
		source $include_flavour
	fi
}

# Docker image output
default_image_name="devel"
[ "${HOST_CONTAINER_FLAVOUR}" ] && default_image_name="$default_image_name-$HOST_CONTAINER_FLAVOUR"
DOCKER_DEVEL_IMAGE="${DOCKER_DEVEL_IMAGE:-$default_image_name}"
DOCKER_DEVEL_TAG="${DOCKER_DEVEL_TAG:-latest}"
