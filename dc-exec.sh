#!/bin/bash
#
# Developer containers execution helper.
#

DC_DIR="$(dirname "$(readlink -f "$0")")/dc" && cd "$DC_DIR"

container_get_ip() {
	container="$1"
	iface="${2:-eth0}"

	ipv4="$(docker exec -it $container \
		ip addr show dev $iface | \
		grep 'inet ' | \
		awk '{ print $2 }' | \
		cut -d / -f1)"

	echo "$ipv4"
}

container="${1:-}"
if [ -z "$container" ]; then
	echo "Usage: $(basename $0) <container_name> [...]"
	exit 1
fi

source env-host.sh

# If as 2nd argument set run command passed
if [ $# -gt 1 ]; then
	wkspace_dir="$HOST_WORKSPACE_BASE_DIR/$container"
	shift

	cmd="$1"
	case "$cmd" in
	brave-browser|chromium)
		$1 --user-data-dir="$wkspace_dir/.config/$cmd" \
		   --proxy-server="$(container_get_ip $container):8888" \
		   2>&1 > /dev/null
	;;
	*)
		docker exec -it $container $@
	;;
	esac
else
	docker exec -it $container su -l devel -w SSH_AUTH_SOCK
fi
