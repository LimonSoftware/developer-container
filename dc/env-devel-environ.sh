#
# Default devel environ file.
#
#   ENVIRON_FILE: Environment filename to install at /etc/default (this file).
#   INIT_SCRIPT: nitialization script of the container to setup services.
#
#   STORAGE_DIR: User sotrage directory inside the container, useful
#              to share storage across Host and Container.
#   WORKSPACE_DIR: User $HOME dir inside the container.
#
#   WORKSPACE_RUN_DIR: Run directory variable to persist across container runs.
#
# Devices mapped to support networking and docker access.
#
#   DEVICE_TUN: Networking tun device, default: '/dev/net/tun' (optional).
#   DOCKER_SOCK: Docker socket, default: '/var/run/docker.sock' (optional).
#

# Add host user context, now git and ssh config extensions.
add_host_user_context() {
	local wkspace_dir="$1"
	local user_name="$2"
	local user_group="$3"
	local host_user_context="$4"
	local host_user_home="$5"

	if [ "$host_user_context" == "1" ]; then
		for f in .gitconfig .ssh/config; do
			dirname="$(dirname $f)"
			filename="$(basename $f)"

			if [ -f "$host_user_home/$f" ] && [ ! -f "$WORKSPACE_DIR/$f" ]; then
				mkdir -p "$WORKSPACE_DIR/$dirname"
				chown $user_name:$user_group $WORKSPACE_DIR/$dirname

				case "$f" in
				.gitconfig)
					cat <<EOF >"$wkspace_dir/$f"
[include]
    path = $host_user_home/$f
EOF
				;;
				.ssh/config)
					echo "Include $host_user_home/$f" > "$wkspace_dir/$f"
				;;
				*)
					echo "ERROR: add_user_context not supported file ($f)"
					exit 1
				esac

				chown $user_name:$user_group $wkspace_dir/$f
			fi
		done
	fi
}

# Add /etc/skel/.* files if aren't yet
add_user_skel() {
	local wkspace_dir="$1"
	local user_name="$2"
	local user_group="$3"

	for f in /etc/skel/.*; do
		wf="$wkspace_dir/$(basename $f)"

		if [ ! -f "$wf" ]; then
			cp "$f" "$wf"
			chown $user_name:$user_group $wf
		fi
	done
}

# Add symlinks if not exists yet, this enables being able run/map
# containers volumes inside with same workspace and/or directories.
add_user_storage_workspace() {
	local wkspace_dir="$1"
	local host_wkspace_dir="$2"
	local storage_dir="$3"
	local host_storage_dir="$4"

	if [ ! -L $wkspace_dir ]; then
		ln -s $host_wkspace_dir $wkspace_dir
	fi

	if [ "$storage_dir" ] && [ ! -L $storage_dir ]; then
		ln -s $host_storage_dir $storage_dir
	fi
}

# Get gid based on group name
get_group_id() {
	group_name="$1"
	echo "$(getent group $group_name | awk -F : '{ print $3 }')"
}

ENVIRON_FILE="/etc/default/devel-environ"
INIT_SCRIPT="/usr/local/sbin/start_devel_environ.sh"

# Container mapped workspace
STORAGE_DIR="/storage"
export STORAGE_DIR
WORKSPACE_DIR="/workspace"
export WORKSPACE_DIR

WORKSPACE_RUN_DIR="$WORKSPACE_DIR/.run"
export WORKSPACE_RUN_DIR

# Devices to share within container

DEVICE_TUN="${DEVICE_TUN:-/dev/net/tun}"
DOCKER_SOCK="${DOCKER_SOCK:-/var/run/docker.sock}"
