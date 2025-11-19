# solodolobolo/code-server - A Customized Fork

This is a customized fork of the [LinuxServer.io code-server Docker image](https://github.com/linuxserver/docker-code-server).

**Original Repository:** [https://github.com/linuxserver/docker-code-server](https://github.com/linuxserver/docker-code-server)
Please refer to the original repository for comprehensive documentation, support, and the upstream project details.

[![GitHub Stars](https://img.shields.io/github/stars/solodolobolo/code-server.svg?color=2196F3&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/solodolobolo/code-server)
[![GitHub Release](https://img.shields.io/github/release/solodolobolo/code-server.svg?color=2196F3&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/solodolobolo/code-server/releases)

[Code-server](https://coder.com) is VS Code running on a remote server, accessible through the browser.

## Custom Implementation Details

This custom build of `code-server` includes the following additional features pre-installed:

*   **Docker CLI:** The Docker command-line interface is installed, allowing you to manage Docker containers and images directly from within your `code-server` environment.
*   **Node.js & npm:** Node.js and its package manager `npm` are installed, enabling JavaScript development and access to a vast ecosystem of tools and libraries.
*   **Passwordless Sudo:** The `sudo` utility is installed and configured to allow the default user (`abc`) to execute commands with superuser privileges without needing to enter a password.

## Supported Architectures

This image supports the following architectures:

| Architecture | Tag |
| :----: | ---- |
| x86-64 | `amd64-<version tag>` |
| arm64 | `arm64v8-<version tag>` |

Simply pulling `ghcr.io/solodolobolo/code-server:latest` should retrieve the correct image for your architecture.

## Usage

To get started with this customized `code-server` image, you can use `docker-compose` or the `docker cli`.

### docker-compose (recommended)

```yaml
---
services:
  code-server:
    image: ghcr.io/solodolobolo/code-server:latest
    container_name: code-server
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - PASSWORD=password #optional
      - HASHED_PASSWORD= #optional
      - SUDO_PASSWORD=password #optional
      - SUDO_PASSWORD_HASH= #optional
      - PROXY_DOMAIN=code-server.my.domain #optional
      - DEFAULT_WORKSPACE=/config/workspace #optional
      - PWA_APPNAME=code-server #optional
    volumes:
      - /path/to/code-server/config:/config
    ports:
      - 8443:8443
    restart: unless-stopped
```

### docker cli

```bash
docker run -d \
  --name=code-server \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e PASSWORD=password `#optional` \
  -e HASHED_PASSWORD= `#optional` \
  -e SUDO_PASSWORD=password `#optional` \
  -e SUDO_PASSWORD_HASH= `#optional` \
  -e PROXY_DOMAIN=code-server.my.domain `#optional` \
  -e DEFAULT_WORKSPACE=/config/workspace `#optional` \
  -e PWA_APPNAME=code-server `#optional` \
  -p 8443:8443 \
  -v /path/to/code-server/config:/config \
  --restart unless-stopped \
  ghcr.io/solodolobolo/code-server:latest
```

## Parameters

Common parameters you might use:

| Parameter | Function |
| :----: | --- |
| `-p 8443:8443` | web gui |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Etc/UTC` | specify a timezone to use, see this [list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List). |
| `-e PASSWORD=password` | Optional web gui password, if `PASSWORD` or `HASHED_PASSWORD` is not provided, there will be no auth. |
| `-e HASHED_PASSWORD=` | Optional web gui password, overrides `PASSWORD`, instructions on how to create it is below. |
| `-e SUDO_PASSWORD=password` | If this optional variable is set, user will have sudo access in the code-server terminal with the specified password. |
| `-e SUDO_PASSWORD_HASH=` | Optionally set sudo password via hash (takes priority over `SUDO_PASSWORD` var). Format is `$type$salt$hashed`. |
| `-v /config` | Contains all relevant configuration files. |
| `--read-only=true` | Run container with a read-only filesystem. |
| `--user=1000:1000` | Run container with a non-root user. |

For more advanced parameters and details, please refer to the [original LinuxServer.io code-server documentation](https://docs.linuxserver.io/images/docker-code-server).

## User / Group Identifiers

When using volumes (`-v` flags), permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify. Example: `id your_user` will show `uid=1000(your_user) gid=1000(your_user)`.

## Building locally

If you want to make local modifications to this image for development purposes or just to customize the logic:

```bash
git clone https://github.com/solodolobolo/code-server.git
cd code-server
docker build \
  --no-cache \
  --pull \
  -t ghcr.io/solodolobolo/code-server:latest .
```

The ARM variants can be built on x86_64 hardware and vice versa using `lscr.io/linuxserver/qemu-static`.

## Versions

*   **Custom Implementation:** Added Docker CLI, Node.js, npm, and `sudo` for single password entry per session.
