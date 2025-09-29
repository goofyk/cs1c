FROM debian:bullseye-slim

ARG RING_VERSION
ARG JAVA_VERSION
ARG CS_HOST
ARG CS_PORT
ARG CS_VERSION
ARG POSTGRES_HOST
ARG POSTGRES_PORT
ARG POSTGRES_DB
ARG POSTGRES_USER
ARG POSTGRES_PASSWORD

ENV JAVA_HOME="/usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64/"
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV PATH="$PATH:$JAVA_HOME/bin"
ENV PATH="$PATH:/opt/1C/1CE/components/1c-enterprise-ring-$RING_VERSION-x86_64"
ENV CS_HOST=$CS_HOST
ENV CS_PORT=$CS_PORT
ENV CS_VERSION=$CS_VERSION
ENV POSTGRES_HOST=$POSTGRES_HOST
ENV POSTGRES_PORT=$POSTGRES_PORT
ENV POSTGRES_DB=$POSTGRES_DB
ENV POSTGRES_USER=$POSTGRES_USER
ENV POSTGRES_PASSWORD=$POSTGRES_PASSWORD
ENV MINIO_HOST=$MINIO_HOST
ENV MINIO_PORT=$MINIO_PORT
ENV MINIO_BUCKET=$MINIO_BUCKET
ENV MINIO_USER=$MINIO_USER
ENV MINIO_PASSWORD=$MINIO_PASSWORD

WORKDIR /app

RUN mkdir -p /usr/share/man/man1 && \
	apt-get update && apt-get install -y \
	wget curl gawk libasound2 libfreetype6 libfontconfig1 libx11-6 libxdmcp6 libxext6 libxrender1 libxtst6 libxi6 libxau6 libxcb1 openjdk-11-jdk jq python3 python3-pip \
	systemd net-tools telnet

COPY srv/1c_cs_${CS_VERSION}_linux_x86_64.tar.gz .
RUN tar xzf ./*.tar.gz \
	&& ./1ce-installer-cli install --ignore-signature-warnings \
	&& rm -rf * 

RUN mv /bin/pidof /bin/_pidof && cp /bin/echo /bin/pidof 	
RUN apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY srv/*.sh ./
RUN chmod +x ./*.sh

COPY srv/s3.py ./s3.py
RUN pip install --no-cache-dir --upgrade pip \
  	&& pip install --no-cache-dir minio

RUN ./init.sh
