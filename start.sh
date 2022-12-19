#!/bin/sh

ntpd -d -q -n -p 0.pool.ntp.org &
/xray -config /xray.json &
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
