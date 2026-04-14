# Actual Budget on the Mac Mini

This directory contains the minimal Docker Compose deployment used on `sylvan@Sylvans-mac-mini.local`.

## Layout

- `compose.yaml`: Actual Budget server container built from the local source checkout on the Mac mini
- `.env.example`: port and source checkout path
- `data/`: persistent budget storage on the target machine

## Deploy

Build from the local source checkout on the Mac mini:

```bash
mkdir -p ~/Documents/projects/actual
mkdir -p ~/Documents/projects/actualbudget
mkdir -p ~/Documents/projects/actualbudget/data
rsync -av --delete --exclude '.env' --exclude 'data/' ~/.config/services/actualbudget/ ~/Documents/projects/actualbudget/
cd ~/Documents/projects/actualbudget
cp -n .env.example .env
docker compose up -d --build
```

Or use the repo helper script:

```bash
~/.config/scripts/deploy-actualbudget-to-mac-mini.sh
```

## Access

Start with local network access:

```text
http://Sylvans-Mac-mini.local:5006
```

If you want to expose it beyond the LAN later, add HTTPS with a reverse proxy or Tailscale.
