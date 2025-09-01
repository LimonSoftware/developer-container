#
# Yocto build support for devel containers.
#
# Install Yocto quickstart required packages.
#
# https://docs.yoctoproject.org/brief-yoctoprojectqs/index.html#build-host-packages
#
DOCKER_OS_DEVEL_PKGS=" \
	$DOCKER_OS_DEVEL_PKGS \
	build-essential \
	chrpath \
	cpio \
	debianutils \
	diffstat \
	file \
	gawk \
	gcc \
	git \
	iputils-ping \
	libacl1 \
	liblz4-1 \
	locales \
	python3 \
	python3-git \
	python3-jinja2 \
	python3-pexpect \
	python3-pip \
	python3-subunit socat \
	texinfo \
	unzip \
	wget \
	xz-utils \
	zstd \
"

DOCKER_OS_TOOLS_CMD="$DOCKER_OS_TOOLS_CMD && \
	sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen && \
	echo 'LANG=en_US.UTF-8' > /etc/default/locale && \
	locale-gen en_US.UTF-8
"
