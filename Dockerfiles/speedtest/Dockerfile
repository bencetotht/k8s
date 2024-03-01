FROM alpine:3

USER root
RUN apk add --no-cache curl python3
RUN curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh 


USER speed
ENTRYPOINT [ "speedtest", "--help" ]