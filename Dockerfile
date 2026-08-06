FROM alpine:latest

RUN apk add --no-cache curl unzip ca-certificates

# دانلود Xray
RUN curl -sL https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o /tmp/xray.zip && \
    unzip /tmp/xray.zip -d /tmp && \
    install -m 755 /tmp/xray /usr/local/bin/xray && \
    mkdir -p /usr/local/share/xray && \
    cp /tmp/geoip.dat /usr/local/share/xray/ && \
    cp /tmp/geosite.dat /usr/local/share/xray/ && \
    rm -rf /tmp/*

COPY config.json /usr/local/share/xray/config.json

EXPOSE 8080

CMD ["/usr/local/bin/xray", "run", "-config=/usr/local/share/xray/config.json"]
