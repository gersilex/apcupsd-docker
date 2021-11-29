FROM alpine:3.15.0

RUN apk add --update apcupsd curl tzdata && \
    rm -rf /tmp/* /var/cache/apk/*

ADD apcupsd.conf scripts/* /etc/apcupsd/
ADD launch.sh entrypoint.sh /usr/local/bin/

RUN chmod a+x /etc/apcupsd/health_check.sh && \
    chmod a+x /etc/apcupsd/send_telegram_message.sh && \
    chmod a+x /etc/apcupsd/changeme && \
    chmod a+x /etc/apcupsd/commfailure &&\
    chmod a+x /etc/apcupsd/commok && \
    chmod a+x /etc/apcupsd/doshutdown && \
    chmod a+x /etc/apcupsd/offbattery && \
    chmod a+x /etc/apcupsd/onbattery && \
    chmod a+x /usr/local/bin/launch.sh && \
    chmod a+x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

CMD [ "/usr/local/bin/launch.sh" ]
