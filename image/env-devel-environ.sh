#
# Default devel environ file
#
# WORKSPACE_DIR: User $HOME dir inside the container.
# STORAGE_DIR: User sotrage directory inside the container, useful
#              to share storage across Host and Container.
#

# Container mapped workspace
WORKSPACE_DIR="/workspace"
export WORKSPACE_DIR
STORAGE_DIR="/storage"
export STORAGE_DIR
