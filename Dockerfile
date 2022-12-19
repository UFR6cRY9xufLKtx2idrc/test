FROM alpine:edge

ARG CADDYIndexPage="https://github.com/OrbitalEnterprises/eve-market-strategies/archive/master.zip"

ADD etc/Caddyfile /tmp/Caddyfile
ADD etc/xray.json /tmp/xray.json
ADD start.sh /start.sh
ENV ENV="/etc/profile"

RUN apk update && \
    apk add --no-cache ca-certificates caddy wget && \
    wget -O Xray-linux-64.zip https://github.com/XTLS/Xray-core/releases/download/v1.6.6-2/Xray-linux-64.zip && \
    unzip Xray-linux-64.zip && \
    chmod +x /xray && \
    rm -rf /var/cache/apk/* && \
    rm -f Xray-linux-64.zip && \
    ntpd -d -q -n -p 0.pool.ntp.org && \
    mkdir -p /etc/caddy/ /usr/share/caddy && echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt && \
    wget $CADDYIndexPage -O /usr/share/caddy/index.html && unzip -qo /usr/share/caddy/index.html -d /usr/share/caddy/ && mv /usr/share/caddy/*/* /usr/share/caddy/ && \
    cat /tmp/Caddyfile | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(caddy hash-password --plaintext $AUUID)/g" >/etc/caddy/Caddyfile && \
    cat /tmp/xray.json | sed -e "s/\$AUUID/$AUUID/g" >/xray.json

RUN chmod +x /start.sh

CMD /start.sh
