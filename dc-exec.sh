#!/bin/bash
#
# Developer containers execution helper.
#

DC_BASE_DIR="$(dirname "$(readlink -f "$0")")" && cd "$DC_BASE_DIR"

source acs.sh

DC_DIR="$DC_BASE_DIR/dc" && cd "$DC_DIR"

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

# Docker exec base command
DOCKER_EXEC="docker exec -e TERM -it"

# When no cmd is specified execute shell via login (su -l) and
# add SSH_AUTH_SOCK if set.
user_cmd="su -l $USER_NAME -w TERM --pty"
[ "${SSH_AUTH_SOCK:-}" ] && user_cmd="$user_cmd -w SSH_AUTH_SOCK"

# SSH execution via the container
dc_exec_ssh() {
	# XXX: By default disable strict host key verification.
	#      Developer containers are intended to non-production workflow.
	ssh_args="$@"
	$DOCKER_EXEC $container $user_cmd -c "ssh -o StrictHostKeyChecking=no $ssh_args"
}

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

	wkspace_dc_dir="$wkspace_dir/.dc"
	mkdir -p "$wkspace_dc_dir"

	acs_init "$wkspace_dc_dir"

	cmd="$1"
	case "$cmd" in
	acs-ip)
		acs_ip $@
		echo -ne "$ACS_IP"
	;;
	acs-log)
		acs_id $@
		acs_log $ACS_ID
	;;
	acs-ping)
		acs_ip $@
		ping_cmd="ping -c 4 -W 5 $ACS_IP"
		$DOCKER_EXEC $container $user_cmd -c "$ping_cmd"
	;;
	acs-ssh|acs-ssh-proxy)
		acs_ip $@ && shift && shift

		opts=""
		if [ "$cmd" == "acs-ssh-proxy" ]; then
			opts="-L *:9999:127.0.0.1:8888"
		fi
		user="$(acs_ssh_user $ACS_ID)"

		dc_exec_ssh "$opts $user@$ACS_IP $@"
	;;
	acs-state)
		acs_id $@ && shift && shift
		state="${1:-}"

		acs_state $ACS_ID $state
	;;
	brave-browser|brave-browse-proxy|chromium|chromium-proxy)
		container_ip="$(container_get_ip $container)"
		proxy_server="$container_ip:8888"
		user_data="$wkspace_dir/.config/$cmd"

		# If command has -proxy suffix
		if [[ "$cmd" =~ -proxy ]]; then
			proxy_server="$container_ip:9999"
			user_data="$user_data.proxy"
			cmd="$(echo $cmd | sed s/-proxy//g)"
		fi

		# Use proxy server from user cmdline.
		# Add special proxy userdata folder to avoid
		# interfer with default proxy session.
		if [ -n "${2:-}" ]; then
			proxy_server="$2"
			user_data="$user_data.customproxy"
		fi

		$cmd --user-data-dir="$user_data" \
		     --proxy-server="$proxy_server" 2>&1 > /dev/null

	;;
	ssh)
		shift
		dc_exec_ssh "$@"
	;;
	*)
		$DOCKER_EXEC $container $@
	;;
	esac
else
	$DOCKER_EXEC $container $user_cmd
fi
