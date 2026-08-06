FROM alpine:latest

# نصب ابزارها
RUN apk add --no-cache curl unzip ca-certificates

# دانلود آخرین نسخه Xray
RUN curl -sL https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o /tmp/xray.zip && \
    unzip /tmp/xray.zip -d /tmp && \
    mv /tmp/xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    mkdir -p /usr/local/share/xray && \
    mv /tmp/geoip.dat /usr/local/share/xray/ 2>/dev/null || true && \
    mv /tmp/geosite.dat /usr/local/share/xray/ 2>/dev/null || true && \
    rm -rf /tmp/*

COPY config.json /etc/xray/config.json

EXPOSE 8080

CMD ["xray", "run", "-config", "/etc/xray/config.json"]
