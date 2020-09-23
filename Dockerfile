FROM alpine:latest

RUN apk update && apk add --no-cache apcupsd 
ADD apcupsd.conf /etc/apcupsd/apcupsd.conf
ADD apccontrol /etc/apcupsd/apccontrol
ADD entryPoint.sh /entryPoint.sh

CMD [ "/bin/sh", "-c", "/entryPoint.sh" ]
EXPOSE 3551/tcp
