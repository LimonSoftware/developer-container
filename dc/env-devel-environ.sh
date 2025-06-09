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

ENVIRON_FILE="/etc/default/devel-environ"
INIT_SCRIPT="/usr/local/sbin/start_devel_environ.sh"

# Container mapped workspace
STORAGE_DIR="/storage"
export STORAGE_DIR
WORKSPACE_DIR="/workspace"
export WORKSPACE_DIR

WORKSPACE_RUN_DIR="$WORKSPACE_DIR/.run"
export WORKSPACE_RUN_DIR
