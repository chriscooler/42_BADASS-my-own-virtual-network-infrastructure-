FROM alpine:latest

RUN apk update
COPY add_Ip_Host1.sh /usr/local/bin/add_Ip_Host1.sh
RUN chmod +x /usr/local/bin/add_Ip_Host1.sh


ENTRYPOINT ["/usr/local/bin/add_Ip_Host1.sh"]
