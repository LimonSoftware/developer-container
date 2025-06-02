#!/bin/bash
#
# Tinyproxy run script
#

TINYPROXY_CONF="/etc/tinyproxy/tinyproxy.conf"

grep -q "Allow 172.17.0.0/16" /etc/tinyproxy/tinyproxy.conf || \
	cat <<EOF >>"$TINYPROXY_CONF"
# Allow container network
Allow 172.17.0.0/16
EOF
 
/usr/bin/tinyproxy -c $TINYPROXY_CONF
