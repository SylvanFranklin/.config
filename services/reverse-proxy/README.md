# Reverse Proxy for the Mac Mini

This directory contains the reverse proxy stack for `sylvan@Sylvans-mac-mini.local`.

## What it does

- Runs Caddy on ports `80` and `443`
- Terminates HTTPS and routes friendly hostnames to the existing local services
- Uses Caddy's internal CA by default so the proxy can be deployed before DNS and public cert automation are finished
- Includes a ready-to-enable Namecheap DNS challenge config for real public certificates

## Hostname map

- `vimothee.online` -> service index
- `portainer.vimothee.online` -> Portainer on `9443`
- `budget.vimothee.online` -> Actual Budget on `5006`
- `cal.vimothee.online` -> Cal.com on `3000`
- `notebook.vimothee.online` -> Open Notebook on `5055`
- `headlamp.vimothee.online` -> Headlamp on `8080`
- `jellyfin.vimothee.online` -> Jellyfin on `8096`

## Deploy

Sync this directory to the Mac mini and launch it there:

```bash
mkdir -p ~/Documents/projects/reverse-proxy
rsync -av --delete --exclude '.env' ~/.config/services/reverse-proxy/ ~/Documents/projects/reverse-proxy/
cd ~/Documents/projects/reverse-proxy
cp -n .env.example .env
docker compose up -d --build
```

Or use the repo helper script:

```bash
~/.config/scripts/deploy-reverse-proxy-to-mac-mini.sh
```

## DNS plan

Preferred private setup:

- In Namecheap Advanced DNS, create `A` record `@` -> `100.85.115.15`
- In Namecheap Advanced DNS, create `A` record `*` -> `100.85.115.15`

That keeps access private to devices on the Tailscale tailnet while still allowing real certificates once DNS-01 is enabled.

## Public HTTPS upgrade

The current `Caddyfile` uses `tls internal`. To switch to publicly trusted certificates:

1. Ensure your Namecheap account can use the production API
2. Enable Namecheap API access and whitelist the current public IPv4 of the Mac mini: `65.183.133.73`
3. Put your credentials in `.env`
4. Replace `Caddyfile` with `Caddyfile.namecheap`
5. Rebuild and restart the stack

```bash
cd ~/Documents/projects/reverse-proxy
cp .env.example .env
$EDITOR .env
cp Caddyfile.namecheap Caddyfile
docker compose up -d --build
```

## Important Namecheap API note

Namecheap production API access has account requirements. As of Namecheap's FAQ, your account must meet at least one of these:

- at least 20 domains under the account
- at least $50 account balance
- at least $50 spent within the last 2 years

If your account does not meet that bar, the practical fallback is either:

- keep `tls internal`, or
- expose `80` and `443` from your router and use standard HTTP-01 validation instead
