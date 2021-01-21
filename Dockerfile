FROM alpine

LABEL maintainer="letssudormrf"

ENV CONFIG="*.ovpn"

RUN set -ex \
    && sed -i 's/https:/http:/g' /etc/apk/repositories \
    && apk --update add --no-cache openvpn dante-server socat \
    && printf "logoutput: stderr\n\ninternal: 0.0.0.0 port = 1080\nexternal: tun0\n\nuser.unprivileged: sockd\n\nsocksmethod: none\nclientmethod: none\n\nclient pass {\n    from: 0.0.0.0/0 to: 0.0.0.0/0\n    log: error\n}\n\nsocks pass {\n    from: 0.0.0.0/0 to: 0.0.0.0/0\n}" >> /etc/sockd.conf \ 
    && sed -i '/#\ and\ try\ and\ let\ resolvconf\ handle\ it/a\pkill sockd\nsockd -D' /etc/openvpn/up.sh \
    && sed -i '/#\ Contributed\ by\ Roy\ Marples\ (uberlord@gentoo.org)/a\pkill sockd' /etc/openvpn/down.sh \
    && rm -rf /var/cache/apk/*

COPY entrypoint.sh /usr/local/bin/

RUN chmod a+rwx /usr/local/bin/entrypoint.sh

WORKDIR /tmp

VOLUME ["/tmp"]

EXPOSE 1080

CMD ["entrypoint.sh"]
