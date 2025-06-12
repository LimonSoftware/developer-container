#
# ACS nop implementation
#

acs_ip_get_nop() {
	local id="$1"

	echo "127.0.0.1"
}

acs_ssh_user_nop() {
	local id="$1"

	echo "$USER"
}
