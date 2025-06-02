#!/bin/bash
#
# Tailscaled run script
#
 
source /etc/default/tailscaled

TAILSCALED_DIR="$WORKSPACE_DIR/run/tailscaled"
mkdir -p "$TAILSCALED_DIR"

/usr/sbin/tailscaled --state="$TAILSCALED_DIR/tailscaled.state" --socket=/run/tailscale/tailscaled.sock --port=${PORT} $FLAGS
