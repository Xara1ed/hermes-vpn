FROM alpine:latest

# نصب ابزارهای مورد نیاز
RUN apk add --no-cache curl unzip

# دانلود Xray
RUN curl -sL https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o /tmp/xray.zip && \
    unzip /tmp/xray.zip -d /tmp && \
    mv /tmp/xray /usr/local/bin/xray && \
    mv /tmp/geoip.dat /usr/local/share/ 2>/dev/null || true && \
    mv /tmp/geosite.dat /usr/local/share/ 2>/dev/null || true && \
    chmod +x /usr/local/bin/xray && \
    rm -rf /tmp/*

# کپی کانفیگ
COPY config.json /etc/xray/config.json

# پورت
ENV PORT=8080

# اجرا
CMD ["xray", "run", "-config", "/etc/xray/config.json"]
