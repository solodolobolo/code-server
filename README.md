```markdown
# Custom code-server Build

A custom container based on [LinuxServer.io](https://linuxserver.io) featuring code-server with integrated Docker CLI and Node.js development environments.
For more information, please refer to the official [linuxserver/code-server](https://github.com/linuxserver/docker-code-server) repository.

## Custom Features

This build incorporates the following modifications to the standard environment:

* **Docker CLI:** Installed for container orchestration (requires socket mount).
* **Node.js:** Integrated Node.js environment with `npm@latest`.
* **Passwordless Sudo:** The `abc` user is granted `NOPASSWD` rights for development flexibility.

## Supported Architectures

| Architecture | Available | Tag |
| --- | --- | --- |
| x86-64 | ✅ | amd64 |
| arm64 | ✅ | arm64 |

## Application Setup

Access the webui at `http://<your-ip>:8443`.

### Docker CLI Usage

To use Docker commands within the code-server terminal, you must mount the host Docker socket:
`-v /var/run/docker.sock:/var/run/docker.sock`

**Note:** The container currently requires `sudo` to run Docker commands on the host.

### User Configuration

For github integration, drop your ssh key in to `/config/.ssh`. Set your git identity:

```bash
git config --global user.name "username"
git config --global user.email "email address"

```

## Usage

### docker-compose

```yaml
---
services:
  code-server:
    image: solodolobolo/code-server:latest
    container_name: code-server
    restart: unless-stopped
    ports:
      - 8443:8443
    volumes:
      - /path/to/code-server/config:/config
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - PUID=${PUID:-1000}
      - PGID=${PGID:-1000}       - TZ=${TZ:-Etc/UTC}
      - PASSWORD=${PASSWORD:-password}
      - HASHED_PASSWORD=${HASHED_PASSWORD:-}
      - SUDO_PASSWORD=${SUDO_PASSWORD:-password}
      - SUDO_PASSWORD_HASH=${SUDO_PASSWORD_HASH:-}
      - PROXY_DOMAIN=${PROXY_DOMAIN:-}
      - DEFAULT_WORKSPACE=${DEFAULT_WORKSPACE:-/config/workspace}
      - PWA_APPNAME=${PWA_APPNAME:-code-server}
      - DOCKER_MODS=${DOCKER_MODS:-linuxserver/mods:code-server-golang}

```

### docker cli

```bash
docker run -d \
  --name=code-server \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e PASSWORD=password \
  -e HASHED_PASSWORD= \
  -e SUDO_PASSWORD=password \
  -e SUDO_PASSWORD_HASH= \
  -e PROXY_DOMAIN=code-server.my.domain \
  -e DEFAULT_WORKSPACE=/config/workspace \
  -e PWA_APPNAME=code-server \
  -p 8443:8443 \
  -v /path/to/code-server/config:/config \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --restart unless-stopped \
  solodolobolo/code-server:latest

```

## Parameters

| Parameter | Function |
| --- | --- |
| `-p 8443:8443` | Web GUI port |
| `-v /config` | Persistent configuration |
| `-v /var/run/docker.sock:/var/run/docker.sock` | Host Docker socket for CLI access |
| `-e PUID=1000` | UserID for file permissions |
| `-e PGID=1000` | GroupID for file permissions |
| `-e TZ=Etc/UTC` | Container timezone |
| `-e PASSWORD=password` | Web GUI access password |
| `-e HASHED_PASSWORD=` | Pre-hashed password alternative for the Web GUI |
| `-e SUDO_PASSWORD=password` | Password required when executing commands with `sudo` |
| `-e SUDO_PASSWORD_HASH=` | Pre-hashed alternative for the sudo password |
| `-e PROXY_DOMAIN=code-server.my.domain` | Domain name used if proxying code-server |
| `-e DEFAULT_WORKSPACE=/config/workspace` | Default folder opened in the workspace |
| `-e PWA_APPNAME=code-server` | Progressive Web App name |
| `-e DOCKER_MODS=...` | Additional community container mods (e.g., Golang tools) |

```

```