
# Based on wiorca/docker-windscribe-mono
FROM wiorca/docker-windscribe-mono:latest

# Version
ARG VERSION=0.0.2

# Expose the webadmin port for Radarr
EXPOSE 7878/tcp

# Create a volume for the bittorrent data and library
VOLUME [ "/data", "/movies" ]

# Install mono
RUN apt -y update && apt install -y mediainfo && \
    apt -y autoremove && apt -y clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add in scripts for health check and start-up
ADD app-health-check.sh /opt/scripts/app-health-check.sh
ADD app-startup.sh /opt/scripts/app-startup.sh
ADD app-setup.sh /opt/scripts/app-setup.sh

# Install Radarr
RUN curl -L $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 ) \
    | tar xvz --directory /opt && chmod -R a+rx /opt/Radarr

