FROM alpine:latest

RUN apk -U upgrade && apk add --no-cache apcupsd

ADD apcupsd.conf /etc/apcupsd/apcupsd.conf
ADD doshutdown /etc/apcupsd/doshutdown
ADD launch.sh /usr/local/bin/

CMD [ "/usr/local/bin/launch.sh" ]

