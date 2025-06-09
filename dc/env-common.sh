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

# Docker image output
default_image_name="$DOCKER_OS_IMAGE-devel"
[ "${HOST_CONTAINER_FLAVOUR}" ] && default_image_name="$default_image_name-$HOST_CONTAINER_FLAVOUR"
DOCKER_DEVEL_IMAGE="${DOCKER_DEVEL_IMAGE:-$default_image_name}"
DOCKER_DEVEL_TAG="${DOCKER_DEVEL_TAG:-latest}"
