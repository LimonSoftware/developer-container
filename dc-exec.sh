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

# When no cmd is specified execute shell via login (su -l) and
# add SSH_AUTH_SOCK if set.
user_cmd="su -l $USER_NAME"
[ "${SSH_AUTH_SOCK:-}" ] && user_cmd="$user_cmd -w SSH_AUTH_SOCK"

# When a cmd is specified execute it.
#
# Special cmd handling:
#
# - {brave-browser, chromium}: Execute in host routing the data-dir and
# 			       proxy to container.
# - ssh: Execute user_cmd and append original ssh.
#
if [ $# -gt 1 ]; then
	wkspace_dir="$HOST_WORKSPACE_BASE_DIR/$container"
	shift

	cmd="$1"
	case "$cmd" in
	brave-browser|chromium)
		$cmd --user-data-dir="$wkspace_dir/.config/$cmd" \
		   --proxy-server="$(container_get_ip $container):8888" \
		   2>&1 > /dev/null
	;;
	ssh)
		shift
		# XXX: By default disable strict host key verification.
		#      Developer containers are intended to non-production workflow.
		ssh_opts="-o StrictHostKeyChecking=no"
		ssh_cmd="$cmd $ssh_opts $@"
		docker exec -it $container $user_cmd -c "$ssh_cmd"
	;;
	*)
		docker exec -it $container $@
	;;
	esac
else
	docker exec -it $container $user_cmd
fi
