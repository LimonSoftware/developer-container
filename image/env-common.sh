#
# Common environment across env-{build,run}.sh
#
# Flavour support
#
# DEVEL_CONTAINER_FLAVOUR: If set load customizations, (optional).
#
# Image Output
#
# DOCKER_DEVEL_IMAGE: Output image name
# DOCKER_DEVEL_TAG: Output image tag
#

# Flavour support function
DEVEL_CONTAINER_FLAVOUR="${DEVEL_CONTAINER_FLAVOUR:-}"
common_load_flavour() {
	local type="$1"

	if [ "$DEVEL_CONTAINER_FLAVOUR" ]; then
		include_flavour="flavours/$DEVEL_CONTAINER_FLAVOUR-$type.sh"
		if [ ! -f "$include_flavour" ]; then
			echo "ERROR: Flavour ($DEVEL_CONTAINER_FLAVOUR) not supported"
			echo "ERROR: Loading flavour file ($include_flavour)"
			exit 1
		fi
		source $include_flavour
	fi
}

# Docker image output
default_image_name="devel"
[ "${DEVEL_CONTAINER_FLAVOUR}" ] && default_image_name="$default_image_name-$DEVEL_CONTAINER_FLAVOUR"
DOCKER_DEVEL_IMAGE="${DOCKER_DEVEL_IMAGE:-$default_image_name}"
DOCKER_DEVEL_TAG="${DOCKER_DEVEL_TAG:-latest}"

# As common environment within the container (/etc/default/devel-environ)
# installed at build.sh -> install.sh -> setup.sh.
source env-devel-environ.sh
