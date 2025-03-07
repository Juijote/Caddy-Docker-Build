# Caddy

*构建 Caddy Docker 镜像集成插件并上传 [Docker HUB](https://hub.docker.com/r/juijote/caddy)*

## 添加以下插件：
- [cloudflare](https://github.com/caddy-dns/cloudflare)
- [alidns](https://github.com/caddy-dns/alidns) 
- [dnspod](https://github.com/caddy-dns/dnspod  ) 
- [security]( https://github.com/greenpau/caddy-security  ) 
- ~~[docker-proxy](https://github.com/lucaslorentz/caddy-docker-proxy)~~
- [webdav]( https://github.com/mholt/caddy-webdav ) 
- [dynamicdns](https://github.com/mholt/caddy-dynamicdns)
- [ratelimit](https://github.com/mholt/caddy-ratelimit)
- [coraza](https://github.com/corazawaf/coraza-caddy/v2)
- [wol](https://github.com/dulli/caddy-wol)

## 编译 Dockerfile
```
ARG CADDY_VERSION=2.8.4
FROM caddy:${CADDY_VERSION}-builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/caddy-dns/alidns \
    --with github.com/caddy-dns/dnspod \
    --with github.com/greenpau/caddy-security \
    --with github.com/mholt/caddy-webdav \
    --with github.com/mholt/caddy-dynamicdns
    --with github.com/mholt/caddy-ratelimit \
    --with github.com/corazawaf/coraza-caddy/v2 \
    --with github.com/dulli/caddy-wol

FROM caddy:${CADDY_VERSION}

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
```

## compose.yaml
```
services:
    caddy:
        restart: always #重启策略
        image: juijote/caddy:latest #容器镜像
        container_name: caddy #容器名称
        network_mode: caddy-net #加入网络
        hostname: caddy #主机别名
        ports: #端口设置
            - 80:80
            - 443:443
            - 443:443/udp
        environment: #参数设置
            - TZ=Asia/Shanghai #时区
            - CADDY_DOCKER_CADDYFILE_PATH=/etc/caddy/Caddyfile # docker-proxy 插件需求，可暂时兼容原有Caddyfile
            - CADDY_INGRESS_NETWORKS=caddy-net # docker-proxy 插件需求
            - CLOUDFLARE_EMAIL= # DNS相关自行修改，这是cloudflare参数
            - CLOUDFLARE_API_TOKEN= # DNS相关自行修改，这是cloudflare参数
            - ACME_AGREE=true
        volumes: # 挂载设置
#            - /var/run/docker.sock:/var/run/docker.sock # docker-proxy 插件需求
            - ./srv:/srv
            - ./data:/data
            - ./config:/config
            - ./Caddyfile:/etc/caddy/Caddyfile
            - /:/home #方便挂载文件服务器
```
