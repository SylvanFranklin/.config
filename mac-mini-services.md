# Mac Mini Service Inventory

This file documents the services verified as running on `Sylvans-Mac-mini.local` on April 8, 2026.

## Runtime Summary

- `brew services list` showed `colima` as `started`
- `brew services list` showed `tailscale` as `error 1`, so the Tailscale launch agent is still not healthy
- `kubectl get nodes -o wide` showed the single k3s node `colima` as `Ready` on `v1.35.0+k3s1`
- `docker ps` showed the reverse proxy, Portainer, Actual Budget, Cal.com, and Open Notebook stacks running
- `kubectl get svc -A` showed `headlamp` and `jellyfin` exposed through k3s `LoadBalancer` services
- The picker inventory is built from both Docker and k3s because several user-facing services are not managed by k3s
- The picker now collapses multiple endpoints for the same service into one preferred entry, with alternate ports kept in the notes

## Direct Service Endpoints

| Service | URL | Source | Notes |
| --- | --- | --- | --- |
| Actual Budget | `http://Sylvans-Mac-mini.local:5006` | `docker` | Direct Docker port on the Mac mini |
| Cal.com | `http://Sylvans-Mac-mini.local:3000` | `docker` | Direct Docker port on the Mac mini |
| Headlamp | `http://Sylvans-Mac-mini.local:8080` | `k8s` | k3s `LoadBalancer` service in namespace `headlamp` |
| Jellyfin | `http://Sylvans-Mac-mini.local:8096` | `k8s` | k3s `LoadBalancer` service in namespace `media` |
| Open Notebook | `http://Sylvans-Mac-mini.local:5055` | `docker` | Direct Docker port on the Mac mini |
| Open Notebook | `http://Sylvans-Mac-mini.local:8502` | `docker` | Secondary Open Notebook UI port |
| Portainer | `https://Sylvans-Mac-mini.local:9443` | `docker` | Direct Portainer HTTPS endpoint |
| SurrealDB | `http://Sylvans-Mac-mini.local:8000` | `docker` | Direct SurrealDB HTTP API port |

## Internal Runtime Components

- Docker containers with no Mac-mini host port exposure: `redis`, `database` (PostgreSQL), `open-notebook-ollama-1`
- k3s system components: `coredns`, `metrics-server`, `local-path-provisioner`, and the `svclb-*` load-balancer pods for `headlamp` and `jellyfin`
- Reverse proxy container: `caddy-proxy` on ports `80` and `443`, excluded from the picker because this inventory now focuses on direct local service endpoints

## Refresh Commands

Use these from either this Mac or directly on the Mac mini:

```bash
bash ~/.config/scripts/mac-mini-services.sh
bash ~/.config/scripts/mac-mini-services.sh --refresh
bash ~/.config/scripts/mac-mini-services.sh --markdown
ssh sylvan@Sylvans-mac-mini.local 'eval "$(/opt/homebrew/bin/brew shellenv)"; brew services list'
ssh sylvan@Sylvans-mac-mini.local 'eval "$(/opt/homebrew/bin/brew shellenv)"; docker ps'
ssh sylvan@Sylvans-mac-mini.local 'eval "$(/opt/homebrew/bin/brew shellenv)"; kubectl get svc -A -o wide'
```

## Cache Behavior

- Default reads use a local cache at `${XDG_CACHE_HOME:-$HOME/.cache}/mac-mini-services.tsv`
- The cache is considered fresh for the current calendar day
- After the day rolls over, the picker serves the last cached list immediately and refreshes in the background once
- `--refresh` forces an immediate live rebuild when you want to pick up changes right away

## tmux Picker

- `Prefix + m` opens the dynamic Mac mini service picker from [tmux.conf](/Users/sylvanfranklin/.config/tmux/tmux.conf)
- In Ghostty, `Cmd-M` is passed through as `prefix m` via [config](/Users/sylvanfranklin/.config/ghostty/config)
- The picker script lives at [mac-mini-services-picker.sh](/Users/sylvanfranklin/.config/scripts/mac-mini-services-picker.sh)
- The inventory source script lives at [mac-mini-services.sh](/Users/sylvanfranklin/.config/scripts/mac-mini-services.sh)
- The picker now uses the same skim flow/style as [tmux-session-dispensary.sh](/Users/sylvanfranklin/.config/scripts/tmux-session-dispensary.sh)
- Cached reads are effectively instantaneous after the first refresh of the day
- `Enter` opens the selected URL
