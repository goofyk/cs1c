FROM debian:bullseye-slim

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV CS_VERSION="26.0.54"
ENV RING_VERSION="0.19.5+12"
ENV JAVA_VERSION="11.0.18_10"
ENV JAVA_HOME="/usr/local/jdk-${JAVA_VERSION}"
ENV PATH="$PATH:$JAVA_HOME/bin"
ENV PATH="$PATH:/opt/1C/1CE/components/1c-enterprise-ring-${RING_VERSION}-x86_64/bin"

WORKDIR /app

RUN mkdir -p /usr/share/man/man1 && \
	apt-get update && apt-get install -y \
	wget curl sudo gawk systemd libasound2 libfreetype6 libfontconfig1 libx11-6 libxdmcp6 libxext6 libxrender1 libxtst6 libxi6 libxau6 libxcb1

RUN curl -O https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.18%2B10/OpenJDK11U-jdk_x64_linux_hotspot_${JAVA_VERSION}.tar.gz \
	&& tar xf ./OpenJDK11U-jdk_x64_linux_hotspot_${JAVA_VERSION}.tar.gz \
	&& mv ./OpenJDK11U-jdk_x64_linux_hotspot_${JAVA_VERSION} /usr/local/

COPY srv/ . 

RUN tar xzf ./distr/*.tar.gz \
	&& ./1ce-installer-cli install --ignore-signature-warnings

RUN apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


COPY start.sh /
COPY init.sh /
RUN chmod +x /*.sh