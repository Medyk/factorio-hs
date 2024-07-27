FROM debian:stable-slim AS builder

ARG VERSION

RUN cd /opt \
 && apt-get -q update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -qy wget xz-utils tar \
 && wget -q -O factorio_headless_x64_${VERSION}.tar.xz https://www.factorio.com/get-download/${VERSION}/headless/linux64 \
 && wget -q -O sha256sums.txt https://www.factorio.com/download/sha256sums/ \
 && sha256sum --ignore-missing -c sha256sums.txt \
 && tar -xJf factorio_headless_x64_${VERSION}.tar.xz


FROM debian:stable-slim

ARG VERSION

LABEL com.factorio.version=${VERSION}

COPY --from=builder /opt/factorio /opt/factorio
COPY files/config.ini /opt/factorio/config/config.ini

RUN adduser --disabled-login --no-create-home --gecos factorio factorio \
 && cd /opt/factorio \
 && mkdir -p /factorio/mods /factorio/saves /factorio/scenarios /factorio/script-output \
 && chown -R factorio:factorio /opt/factorio \
 && ln -s /factorio/mods /opt/factorio/mods \
 && ln -s /factorio/saves /opt/factorio/saves \
 && ln -s /factorio/scenarios /opt/factorio/scenarios \
 && ln -s /factorio/script-output /opt/factorio/script-output

WORKDIR /opt/factorio
USER factorio

VOLUME /factorio
EXPOSE 27015/tcp 34197/udp
ENTRYPOINT [ "/opt/factorio/bin/x64/factorio" ]
CMD [ "--start-server-load-latest", "--server-settings", "/factorio/server-settings.json" ]
