FROM alpine:latest
RUN apk add --no-cache iproute2 iputils
COPY add_Ip_Host2.sh /usr/local/bin/add_Ip_Host2.sh
RUN chmod +x /usr/local/bin/add_Ip_Host2.sh
ENTRYPOINT ["/usr/local/bin/add_Ip_Host2.sh"]
