SSHD_DIR="/workspace/.sshd"

if [ ! -d "$SSHD_DIR" ]; then
	mkdir -p $SSHD_DIR

	ssh-keygen -f ${SSHD_DIR}/ssh_host_rsa_key -N '' -t rsa
	cat << EOF > ${SSHD_DIR}/sshd_config
Port 2222
HostKey ${SSHD_DIR}/ssh_host_rsa_key
PubkeyAuthentication yes
AuthorizedKeysFile  .ssh/authorized_keys
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM yes
Subsystem   sftp  /usr/lib/openssh/sftp-server
PidFile ${SSHD_DIR}/sshd.pid
EOF
fi

/usr/sbin/sshd -f ${SSHD_DIR}/sshd_config
