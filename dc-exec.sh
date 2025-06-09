#!/bin/bash
#
# Developer containers execution helper
#

DC_DIR="$(dirname "$(readlink -f "$0")")/dc" && cd "$DC_DIR"

container="${1:-}"
if [ -z "$container" ]; then
	echo "Usage: $(basename $0) <container_name> [...]"
	exit 1
fi

source env-host.sh

# If as 2nd argument set run command passed
if [ $# -gt 1 ]; then
	shift
	docker exec -it $container $@
else
	docker exec -it $container su -l devel -w SSH_AUTH_SOCK
fi
