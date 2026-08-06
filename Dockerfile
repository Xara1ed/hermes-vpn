FROM alpine:latest
RUN apk add --no-cache curl unzip
RUN curl -sL https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o /tmp/x.zip && \
    unzip /tmp/x.zip -d /tmp && \
    mv /tmp/xray /usr/local/bin/ && \
    chmod +x /usr/local/bin/xray && \
    mv /tmp/geoip.dat /usr/local/bin/ && \
    mv /tmp/geosite.dat /usr/local/bin/ && \
    rm /tmp/x.zip
COPY config.json /config.json
EXPOSE 8080
CMD ["xray", "run", "-c", "/config.json"]
