#
# Yocto host setup support.
#

HOST_DEVICE_KVM="${HOST_DEVICE_KVN:-/dev/kvm}"
HOST_DEVICE_KVM_GID="0"
HOST_DEVICE_LOOP="${HOST_DEVICE_LOOP:-/dev/loop-control}"

if [ -c "${HOST_DEVICE_KVM}" ]; then
	HOST_DEVICE_KVM_GID="$(stat -c %g "$HOST_DEVICE_KVM")"
else
	echo "Warning: KVM device $(HOST_DEVICE_KVM) not found, accel will not work."
	HOST_DEVICE_KVM=""
fi

if [ ! -c "${HOST_DEVICE_LOOP}" ]; then
	echo "Warning: Loop device $(HOST_DEVICE_LOOP) not found."
	HOST_DEVICE_LOOP=""
fi

yocto_host="flavours/yocto/host.sh"
cp "$yocto_host.in" "$yocto_host"
sed -i "s|__HOST_DEVICE_KVM__|$HOST_DEVICE_KVM|g" "$yocto_host"
sed -i "s|__HOST_DEVICE_KVM_GID__|$HOST_DEVICE_KVM_GID|g" "$yocto_host"
sed -i "s|__HOST_DEVICE_LOOP__|$HOST_DEVICE_LOOP|g" "$yocto_host"
