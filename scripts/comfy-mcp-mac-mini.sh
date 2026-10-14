#!/bin/bash
set -euo pipefail
exec /usr/bin/ssh -T -o BatchMode=yes -o ConnectTimeout=10 -o ServerAliveInterval=30 -o ServerAliveCountMax=3 sylvan@100.85.115.15 /Users/sylvan/.config/comfy-mcp/start.sh
