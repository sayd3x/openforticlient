FROM alpine:latest as builder

RUN apk add --no-cache git gcc automake autoconf openssl pkgconfig make libc-dev openssl-dev
RUN	git clone https://github.com/adrienverge/openfortivpn.git openfortivpn && \
	cd openfortivpn && \
	./autogen.sh && \
	./configure --prefix=$PWD/output/usr/local --sysconfdir=$PWD/output/etc && \
	make && \
	make install

FROM alpine:latest

COPY --from=builder /openfortivpn/output/usr/local /usr/local
COPY --from=builder /openfortivpn/output/etc /etc

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
	apk add --no-cache iproute2 ppp ppp-daemon && \
echo $'debug dump\n\
lock\n\
noauth\n\
proxyarp\n\
nodefaultroute\n\
modem\n\
noipdefault\n\
lcp-echo-interval 60\n\
lcp-echo-failure 4\n\
' > /etc/ppp/options && \
	rm -rf /var/cache/apk/* /tmp/*

COPY ./start.sh /start.sh
RUN chmod 777 /start.sh
CMD [ "/start.sh" ]
