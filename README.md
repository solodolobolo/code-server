# Custom code-server Build

A custom container based on [LinuxServer.io](https://linuxserver.io) featuring code-server with integrated Docker CLI, Node.js, and Python development environments.
For more information, please refer to the official [linuxserver/code-server](https://github.com/linuxserver/docker-code-server) repository.

## Custom Features

This build incorporates the following modifications to the standard environment, with all custom runtimes and binaries fully tested and verified prior to publishing:

- **Docker CLI:** Installed natively for terminal container orchestration (requires socket mount).
- **Node.js Environment:** Integrated Node.js environment paired with `npm` and `pnpm`.
- **Python Environment:** Includes Python along with `venv` and development headers.
- **Passwordless Sudo:** The default `abc` user is explicitly granted `NOPASSWD` rights for maximum development flexibility.

## Supported Architectures

This image is built as a multi-arch manifest. Both architectures are available under the single `latest` tag:

| Architecture | Available | Tag |
| --- | --- | --- |
| x86-64 | ✅ | latest |
| arm64 | ✅ | latest |

## Application Setup

Access the webui at `http://<your-ip>:8443`.

### Docker CLI Usage

To use Docker commands within the code-server terminal, you must mount the host Docker socket:
`-v /var/run/docker.sock:/var/run/docker.sock`

**Note:** Because of the passwordless sudo configuration, you can run Docker commands easily inside the terminal using `sudo docker <command>`.

### User Configuration

For GitHub integration, drop your SSH key into `/config/.ssh`. Set your Git identity:

```bash
git config --global user.name "username"
git config --global user.email "email address"

```

## Build Arguments

If you are building the image from source, you can override the default pinned versions past the last known stable configuration by passing build arguments (`--build-arg`):

* `CODE_SERVER_TAG` (Base image tag or digest)
* `NODE_VERSION` (Node.js major version)
* `NPM_VERSION` (Exact npm version)
* `PNPM_VERSION` (Exact pnpm version)
* `PYTHON_VERSION` (Python version)
* `DOCKER_CLI_VERSION` (Exact apt package version string for `docker-ce-cli`)

Example:

```bash
docker build \
  --build-arg NODE_VERSION=22 \
  --build-arg NPM_VERSION=10.9.0 \
  -t solodolobolo/code-server .

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
      - PGID=${PGID:-1000} - TZ=${TZ:-Etc/UTC}
      - PASSWORD=${PASSWORD:-password}
      - HASHED_PASSWORD=${HASHED_PASSWORD:-}
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
| `-e PROXY_DOMAIN=code-server.my.domain` | Domain name used if proxying code-server |
| `-e DEFAULT_WORKSPACE=/config/workspace` | Default folder opened in the workspace |
| `-e PWA_APPNAME=code-server` | Progressive Web App name |
| `-e DOCKER_MODS=...` | Additional community container mods (e.g., Golang tools) |