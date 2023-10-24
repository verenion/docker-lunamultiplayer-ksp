FROM ich777/debian-baseimage:bullseye_amd64

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-lunamultiplayer-ksp"

RUN apt-get update && apt-get -y install --no-install-recommends wget apt-transport-https && \
	wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb && \
	dpkg -i /tmp/packages-microsoft-prod.deb && apt-get update && \
	apt-get -y install --no-install-recommends aspnetcore-runtime-5.0 jq unzip && \
	apt-get -y remove apt-transport-https && \
	apt-get -y autoremove && \
	rm -rf /var/lib/apt/lists/* /tmp/packages-microsoft-prod.deb

ENV DATA_DIR="/lunamultiplayer"
ENV LMP_V="latest"
ENV GAME_PARAMS=""
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV USER="lmp"

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]