#
# Default devel environ file
#
# WORKSPACE_DIR: User $HOME dir inside the container.
# STORAGE_DIR: User sotrage directory inside the container, useful
#              to share storage across Host and Container.
#
# WORKSPACE_RUN_DIR: Run directory variable to persist across container
#                    runs.
#

# Container mapped workspace
WORKSPACE_DIR="/workspace"
export WORKSPACE_DIR
STORAGE_DIR="/storage"
export STORAGE_DIR

WORKSPACE_RUN_DIR="$WORKSPACE_DIR/.run"
export WORKSPACE_RUN_DIR
