FROM alpine:latest

RUN apk update && apk add --no-cache apcupsd

ADD apcupsd.conf /etc/apcupsd/apcupsd.conf
ADD doshutdown /etc/apcupsd/doshutdown

VOLUME [ "/etc/apcupsd", "/var/log/apcupsd" ]

CMD [ "/sbin/apcupsd", "-b" ]
