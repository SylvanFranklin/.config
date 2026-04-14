FROM caddy:2.10-builder-alpine AS builder

RUN xcaddy build v2.10.2 \
    --with github.com/caddy-dns/namecheap

FROM caddy:2.10-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

RUN caddy version && caddy list-modules
