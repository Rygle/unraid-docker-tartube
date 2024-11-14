# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-24.04-v4

# Define working directory.
WORKDIR /tmp

# Generate and install favicons.
RUN \
	APP_ICON_URL=https://raw.githubusercontent.com/angelics/unraid-docker-tartube/main/tartube_icon.png && \
	install_app_icon.sh "$APP_ICON_URL"

# Define download URLs.
ARG TARTUBE_VERSION=2.5.040
# ARG TARTUBE_URL=https://github.com/axcore/tartube/releases/download/v${TARTUBE_VERSION}/python3-tartube_${TARTUBE_VERSION}.deb
ARG TARTUBE_URL=https://github.com/axcore/tartube/releases/download/v2.5.040/python3-tartube_2.5.040.deb

### Install Tartube
RUN	add-pkg \
		python3-matplotlib \
		python3-pip \
		python3-feedparser \
		python3-requests \
		python3-gi \
		gir1.2-gtk-3.0 \
		dbus-x11 \
		at-spi2-core \	
		fonts-wqy-zenhei \
		ffmpeg \
		locales
#		&& \
RUN	sed-patch 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN	locale-gen
RUN	pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir \
		streamlink \
		youtube-dl \
		moviepy \
		cairocffi
#		&& \
RUN	add-pkg --virtual build-dependencies \
		wget
#		&& \
	# echo "download tartube 2.5.040..."
RUN	wget -q https://github.com/axcore/tartube/releases/download/v2.5.040/python3-tartube_2.5.040.deb
RUN	dpkg -i python3-tartube_2.5.040.deb
RUN	del-pkg build-dependencies
RUN	rm -rf /tmp/* /tmp/.[!.]*

# Add files
# USER root
COPY rootfs/ /
# USER 1001
RUN chmod +x /rootfs/startup.sh
	
# Set environment variables.
RUN \
    set-cont-env APP_NAME "Tartube" && \
    set-cont-env APP_VERSION "2.5.040"
	
# Define mountable directories.
VOLUME ["/storage"]
