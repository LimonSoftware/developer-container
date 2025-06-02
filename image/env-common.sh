#
# Common environment across env-{build,run}.sh
#
# Image Output
#
# DOCKER_DEVEL_IMAGE: Output image name
# DOCKER_DEVEL_TAG: Output image tag
#

# Docker image output
DOCKER_DEVEL_IMAGE="${DOCKER_DEVEL_IMAGE:-devel}"
DOCKER_DEVEL_TAG="${DOCKER_DEVEL_TAG:-latest}"

# As common environment within the container (/etc/default/devel-environ)
# installed at build.sh -> install.sh -> setup.sh.
source env-devel-environ.sh
