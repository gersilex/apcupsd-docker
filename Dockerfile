FROM alpine:latest

RUN apk update && apk add --no-cache apcupsd 
ADD apcupsd.conf /etc/apcupsd/apcupsd.conf
ADD apccontrol /etc/apcupsd/apccontrol

CMD [ "/sbin/apcupsd", "-b", "&" ]

EXPOSE 3551/tcp
