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

[ "${STORAGE_DIR}" ] && [ ! -L ${STORAGE_DIR} ] && ln -s \$HOST_STORAGE_DIR ${STORAGE_DIR}
[ ! -L ${WORKSPACE_DIR} ] && ln -s \$HOST_WORKSPACE_DIR ${WORKSPACE_DIR}

add_user_skel "\$WORKSPACE_DIR" "$USER_NAME" "$USER_GROUP"
EOF

cd services
for serv in *.sh; do
  install -m0755 $serv /usr/local/sbin/
  cat <<EOF >> ${INIT_SCRIPT}
/usr/local/sbin/${serv}
EOF
done
cd ../

cat <<EOF >> ${INIT_SCRIPT}
# Nothing else only sleep
while true; do
	sleep 1
done
EOF

chmod +x ${INIT_SCRIPT}

# Flavour support
env_host_load_flavour setup

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
