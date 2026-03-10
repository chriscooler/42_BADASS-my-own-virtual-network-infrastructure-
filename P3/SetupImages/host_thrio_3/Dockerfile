FROM alpine:latest

RUN apk update
COPY add_Ip_Host3.sh /usr/local/bin/add_Ip_Host3.sh
RUN chmod +x /usr/local/bin/add_Ip_Host3.sh


ENTRYPOINT ["/usr/local/bin/add_Ip_Host3.sh"]
