#
# Access functions to be implemented by the user.
#
# Environment
#
# DC_ACS_TYPE: Shell to import implementing access functions.
#
# Functions
#
# acs_ip_get: Gets the IP address associated to ID.
# acs_ssh_user: Gets the SSH User associated to ID.
#

DC_ACS_TYPE="${DC_ACS_TYPE:-nop}"

acs_init() {
	local wkspace="$1"

	acs_wkspace_env="$wkspace/acs"
	[ -f "$acs_wkspace_env" ] && source "$acs_wkspace_env"

	local acs_file="$(realpath ../acs/$DC_ACS_TYPE.sh)"
	if [ ! -f "$acs_file" ]; then
		echo "ERROR: Access file ($acs_file) doesn't exists"
       		exit 1
	fi
	source "$acs_file"
}

acs_ip_get() {
	local id="$1"

	echo "$(acs_ip_get_$DC_ACS_TYPE $id)"
}

acs_ssh_user() {
	local id="$1"

	echo "$(acs_ssh_user_$DC_ACS_TYPE $id)"
}
