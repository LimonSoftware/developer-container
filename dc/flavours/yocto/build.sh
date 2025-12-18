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
	can-utils \
	chrpath \
	cpio \
	debianutils \
	diffstat \
	file \
	gawk \
	gcc \
	gcc-arm-none-eabi \
	git \
	iputils-ping \
	libacl1 \
	libftdi1 \
	libhidapi-hidraw0 \
	liblz4-1 \
	libusb-1.0-0 \
	locales \
	nanopb \
	protobuf-compiler \
	python3 \
	python3-git \
	python3-jinja2 \
	python3-pexpect \
	python3-pip \
	python3-protobuf \
	python3-subunit \
	python3-virtualenv \
	socat \
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
