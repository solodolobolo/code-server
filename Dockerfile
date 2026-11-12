# syntax=docker/dockerfile:1
ARG CODE_SERVER_TAG=latest
ARG NODE_VERSION=24
ARG NPM_VERSION=12.2.2
ARG PNPM_VERSION=11.8.0
ARG PYTHON_VERSION=3.14
ARG DOCKER_CLI_VERSION=5:29.9.3-1~ubuntu.24.04~noble

ARG CODE_SERVER_TAG
FROM lscr.io/linuxserver/code-server${CODE_SERVER_TAG}

ARG NODE_VERSION
ARG NPM_VERSION
ARG PNPM_VERSION
ARG PYTHON_VERSION
ARG DOCKER_CLI_VERSION

# 1. Install base utilities and apt repositories
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    sudo \
    software-properties-common && \
  add-apt-repository ppa:deadsnakes/ppa -y && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Setup Docker & Node.js repository keys and lists
RUN mkdir -p /etc/apt/keyrings && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_VERSION}.x nodistro main" | \
    tee /etc/apt/sources.list.d/nodesource.list > /dev/null

# 3. Install packages (Pinned Docker CLI, Node.js, Python 3.14)
RUN apt-get update && apt-get install -y \
    docker-ce-cli=${DOCKER_CLI_VERSION} \
    nodejs \
    python${PYTHON_VERSION} \
    python${PYTHON_VERSION}-venv \
    python${PYTHON_VERSION}-dev && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# 4. Install exact pinned versions of npm and pnpm globally
RUN npm install -g npm@${NPM_VERSION} && \
  npm install -g pnpm@${PNPM_VERSION}

# 5. Configure passwordless sudo for user 'abc'
RUN echo "abc ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99-passwordless-sudo && \
  chmod 0440 /etc/sudoers.d/99-passwordless-sudo