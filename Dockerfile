FROM debian:jessie
MAINTAINER telyn <telyn@aetheria.co.uk>

USER root
# Install X server, wine, and tools needed to run winetricks
RUN dpkg --add-architecture i386 \
	    && apt-get update \
	    && apt-get install -y --no-install-recommends \
	    xvfb \
	    xauth \
	    x11-utils \
	    x11-xserver-utils \
	    curl \
	    unzip \
	    ca-certificates \
	    cabextract \
	    wine:i386 \
	    && rm -rf /var/lib/apt/lists/*

RUN curl -SL 'https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks' -o /usr/local/bin/winetricks \
		&& chmod +x /usr/local/bin/winetricks
	    
RUN adduser \
	--home /home/wine \
	--disabled-password \
	--shell /bin/bash \
	--gecos "user for running a wine application" \
	--quiet \
	wine


USER wine
ENV HOME /home/wine
ENV WINEPREFIX /home/wine/.wine
ENV WINEARCH win32
WORKDIR /home/wine

COPY install-vcrun6.sh .

# install the installer's dependencies
RUN bash install-vcrun6.sh

# now clean up in the hopes that we'll end up with a smaller image

USER root
RUN apt-get remove -y \
	    xvfb \
	    xauth \
	    x11-xserver-utils \
	    && apt-get autoremove -y

USER wine
ENV HOME /home/wine
ENV WINEPREFIX /home/wine/.wine
ENV WINEARCH win32
WORKDIR /home/wine

RUN rm -f .wine/drive_c/windows/Temp/_vcrun6
RUN rm -rf .cache/winetricks

