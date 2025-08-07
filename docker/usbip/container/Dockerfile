FROM ubuntu:24.10
RUN apt-get update && apt-get install -y \
    usbip \
    linux-tools-generic \
    linux-cloud-tools-generic
EXPOSE 3240
COPY start-usbip-server.sh /usr/local/bin/start-usbip-server.sh
RUN chmod +x /usr/local/bin/start-usbip-server.sh

CMD ["/usr/local/bin/start-usbip-server.sh"]
