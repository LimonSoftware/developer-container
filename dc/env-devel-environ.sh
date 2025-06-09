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

ENVIRON_FILE="/etc/default/devel-environ"
INIT_SCRIPT="/usr/local/sbin/start_devel_environ.sh"

# Container mapped workspace
STORAGE_DIR="/storage"
export STORAGE_DIR
WORKSPACE_DIR="/workspace"
export WORKSPACE_DIR

WORKSPACE_RUN_DIR="$WORKSPACE_DIR/.run"
export WORKSPACE_RUN_DIR
