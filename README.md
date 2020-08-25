# Docker Windscribe Radarr Image

A derivative of wiorca/docker-windscribe that provides Sonarr services.

NOTE: You will need to provide the configuration of Radarr.  I do not provide a default configuration that points to /movies or /data.  It will make your life easier if the paths inside your torrent client (/data) lines up with your radarr image.  I provide /data for torrents/downloads, and /movies for the library.  If you need to add/modify, then feel free to do so to your hearts content.

## About the image

Windscribe docker container that provides Radarr services.  It's a minimalst image that provides very little configuration out of the box.

Simple health-checking is done in the container to verify the tunnel is active, and Radarr is running.

This documentation format is inspired by the great people over at linuxserver.io.

## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=docker-windscribe-radarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=America/New_York \
  -e WINDSCRIBE_USERNAME=username \
  -e WINDSCRIBE_PASSWORD=password \
  -e WINDSCRIBE_PROTOCOL=stealth \
  -e WINDSCRIBE_PORT=80 \
  -e WINDSCRIBE_PORT_FORWARD=9999 \
  -e WINDSCRIBE_LOCATION=US \
  -e WINDSCRIBE_LANBYPASS=on \
  -e WINDSCRIBE_FIREWALL=on \
  -v /location/on/host:/config \
  -v /location/elsewhere:/data \
  -v /location/elsewhere:/movies \
  --dns 8.8.8.8 \
  -p 7878:7878 \
  --cap-add NET_ADMIN \
  --restart unless-stopped \
  wiorca/docker-windscribe-radarr
```


### docker-compose

Compatible with docker-compose schemas.

```
---
version: "2.1"
services:
  docker-windscribe-radarr:
    image: wiorca/docker-windscribe-radarr
    container_name: docker-windscribe-radarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
      - WINDSCRIBE_USERNAME=username
      - WINDSCRIBE_PASSWORD=password
      - WINDSCRIBE_PROTOCOL=stealth
      - WINDSCRIBE_PORT=80
      - WINDSCRIBE_PORT_FORWARD=9999
      - WINDSCRIBE_LOCATION=US
      - WINDSCRIBE_LANBYPASS=on
      - WINDSCRIBE_FIREWALL=on
    volumes:
      - /location/on/host:/config
      - /location/on/host:/data
      - /location/on/host:/movies
    ports:
      - 7878:7878
    dns:
      - 8.8.8.8
    cap-add:
      - NET_ADMIN
    restart: unless-stopped
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above).

This docker container doesn't define any new configuration parameters.  The configuration of qbittorrent is achieved through files.

The following parameters are inhereted from the parent container:

| Parameter | Examples/Options | Function |
| :----: | --- | --- |
| PUID | 1000 | The nummeric user ID to run the application as, and assign to the user docker_user |
| PGID | 1000 | The numeric group ID to run the application as, and assign to the group docker_group |
| TZ=Europe/London | The timezone to run the container in |
| WINDSCRIBE_USERNAME | username | The username used to connect to windscribe |
| WINDSCRIBE_PASSWORD | password | The password associated with the username |
| WINDSCRIBE_PROTOCOL | stealth OR tcp OR udp | The protocol to use when connecting to windscribe, which must be on 'windscribe protocol' list |
| WINDSCRIBE_PORT | 443, 80, 53 | The port to connect to windscribe over, which must be on 'windscribe port' list for that protocol |
| WINDSCRIBE_PORT_FORWARD | 9898 | The port you have convigured to forward via windscribe. Not used by this container, but made available |
| WINDSCRIBE_LOCATION | US | The location to connect to, which must be on 'windscribe location' list |
| WINDSCRIBE_LANBYPASS | on, off | Allow other applications on the docker bridge to connect to this container if on |
| WINDSCRIBE_FIREWALL | on, off | Enable the windscribe firewall if on, which is recommended. |

## Volumes

| Volume | Example | Function |
| :----: | --- | --- |
| /config | /opt/docker/docker-windscribe-radarr-config | The home directory of docker_user, and where configuration files will live (inhereted from parent)|
| /data | /opt/docker/docker-windscribe-qbittorrent-data | The location where torrent data should be stored (should be consistant with qbittorrent) |
| /movies | /opt/docker/docker-windscribe-radarr-data | The location where the movie data should be stored (could be anywhere, this is an example)|

## Below are the instructions for updating containers:

### Via Docker Run/Create
* Update the image: `docker pull wiorca/docker-windscribe-radarr`
* Stop the running container: `docker stop docker-windscribe-radarr`
* Delete the container: `docker rm docker-windscribe-radarr`
* Recreate a new container with the same docker create parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* Start the new container: `docker start docker-windscribe-radarr`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Compose
* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull docker-windscribe-radarr`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d docker-windscribe-radarr`
* You can also remove the old dangling images: `docker image prune`

### Via Watchtower auto-updater (especially useful if you don't remember the original parameters)
* Pull the latest image at its tag and replace it with the same env variables in one run:
  ```
  docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --run-once docker-windscribe-radarr
  ```
* You can also remove the old dangling images: `docker image prune`

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:
```
git clone https://github.com/wiorca/docker-windscribe-radarr.git
cd docker-windscribe-radarr
docker build \
  --no-cache \
  --pull \
  -t wiorca/docker-windscribe-radarr:latest .
```
