#
# ACS LimonSoftware devices
#
# Environment
#
# DC_ACS_LS_SERVER_HOST: Server hostname/ip to get IP based on ID, <required>.
# DC_ACS_LS_SERVER_USER: User used to get IP based on IDs. default: 'device' (optional).
#
# DC_ACS_LS_SSH_USER: User to login into remote hosts, default: 'root' (optional).
#
#

DC_ACS_LS_SERVER_HOST="${DC_ACS_LS_SERVER_HOST:-}"
DC_ACS_LS_SERVER_USER="${DC_ACS_LS_SERVER_USER:-device}"

DC_ACS_LS_SSH_USER="${DC_ACS_LS_SSH_USER:-root}"

if [ -z "$DC_ACS_LS_SERVER_HOST" ]; then
	echo "ERROR: DC_ACS_TYPE set to 'ls' but DC_ACS_LS_SERVER_HOST is not set."
	exit 1
fi

acs_ip_get_ls() {
	local id="$1"

	output="$(dc_exec_ssh "$DC_ACS_LS_SERVER_USER@$DC_ACS_LS_SERVER_HOST -- --cmd list --id $id")"
	ipv4="$(echo "$output" | grep -o -E "IPv4: (.*)" | sed 's/IPv4: //g' | tr -d '\r')"
	ipv4="$(echo -ne "$ipv4" | tr -d '\r' | tr -d '\n' | tr -d ' ')"

	echo -ne "$ipv4"
}

acs_log_ls() {
	local id="$1"

	echo "$(dc_exec_ssh "$DC_ACS_LS_SERVER_USER@$DC_ACS_LS_SERVER_HOST -- --cmd log --id $id")"
}

acs_ssh_user_ls() {
	local id="$1"

	echo "$DC_ACS_LS_SSH_USER"
}
