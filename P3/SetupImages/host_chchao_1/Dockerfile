FROM alpine:latest

# tiny host container for P3 (no FRR, just a shell)
RUN apk add --no-cache iproute2 iputils

COPY add_ip_host1.sh /usr/local/bin/add_ip_host1.sh
RUN chmod +x /usr/local/bin/add_ip_host1.sh

ENTRYPOINT ["/usr/local/bin/add_ip_host1.sh"]

