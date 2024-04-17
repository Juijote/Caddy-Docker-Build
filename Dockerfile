ARG CADDY_VERSION=2.7.6
FROM caddy:${CADDY_VERSION} AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/caddy-dns/alidns \
    --with github.com/caddy-dns/dnspod

FROM caddy:${CADDY_VERSION}

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

CMD ["caddy", "docker-proxy"]
