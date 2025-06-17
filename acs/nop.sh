#
# ACS nop implementation
#

acs_ip_get_nop() {
	local id="$1"

	echo "127.0.0.1"
}

acs_log_nop() {
	local id="$1"
	echo "nop"
}

acs_ssh_user_nop() {
	local id="$1"

	echo "$USER"
}

acs_state_nop() {
	local id="$1"
	local state="${2:-}"

	echo "$state"
}
