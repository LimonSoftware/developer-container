#!/bin/bash
#
# Setup script for run services
#

source env-common.sh

# Setup services run
install -m0644 env-devel-environ.sh ${ENVIRON_FILE}

cat <<EOF > ${INIT_SCRIPT}
#!/bin/bash
#
# Setup run of services
#

source ${ENVIRON_FILE}

add_user_storage_workspace "\$WORKSPACE_DIR" "\$HOST_WORKSPACE_DIR" "\$STORAGE_DIR" "\$HOST_STORAGE_DIR"
add_user_skel "\$WORKSPACE_DIR" "$USER_NAME" "$USER_GROUP"

add_host_user_context "\$WORKSPACE_DIR" "$USER_NAME" "$USER_GROUP" "$HOST_CONTAINER_USER_CONTEXT" "$HOST_USER_HOME"

# Services setup
EOF

cd services

# Execute tailscaled at end, it blocks any previous
# service execution.
last_service="tailscaled.sh"
for serv in *.sh; do
	install -m0755 $serv /usr/local/sbin/

	if [ "$serv" == "$last_service" ]; then
		continue
	fi
	cat <<EOF >> ${INIT_SCRIPT}
/usr/local/sbin/${serv}
EOF
done
echo "/usr/local/sbin/$last_service" >> ${INIT_SCRIPT}

cd ../

chmod +x ${INIT_SCRIPT}

# Flavour support
env_host_load_flavour setup

# Add host docker group, if is different from host one
docker_gid="$(get_group_id docker)"
if [ "$docker_gid" != "$HOST_DOCKER_GID" ]; then
	group="$(get_group_name $docker_gid)"
	if [ -z "${group:-}" ]; then
		group="dockerhost"
		groupadd -g "$HOST_DOCKER_GID" "$group"
	fi
	USER_GROUPS="$USER_GROUPS,$group"
fi

# Setup user
groupadd -g $USER_GID \
	$USER_GROUP
useradd -d $WORKSPACE_DIR -M \
	-u $USER_UID \
	-g $USER_GID \
	-G $USER_GROUPS \
	-s $USER_SHELL \
	$USER_NAME

# Allow sudo to user
mkdir -p /etc/sudoers.d
cat <<EOF > /etc/sudoers.d/$USER_NAME
$USER_NAME ALL=(ALL) NOPASSWD: ALL
EOF
