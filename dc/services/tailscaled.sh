#!/bin/bash
#
# Tailscaled run script
#
 
source /etc/default/tailscaled

TAILSCALED_DIR="$WORKSPACE_RUN_DIR/tailscaled"
mkdir -p "$TAILSCALED_DIR"

/usr/sbin/tailscaled -statedir "$TAILSCALED_DIR" -socket "/run/tailscale/tailscaled.sock" -port "${PORT}" $FLAGS
