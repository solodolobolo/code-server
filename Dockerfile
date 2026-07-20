# syntax=docker/dockerfile:1
FROM lscr.io/linuxserver/code-server:latest

# Install Docker, Sudo, and Node.js (NodeSource)
RUN \
  apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    sudo \
    software-properties-common && \
  add-apt-repository ppa:deadsnakes/ppa -y && \
  # Docker CLI Setup
  mkdir -p /etc/apt/keyrings && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
  # Node.js 24 Setup
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_24.x nodistro main" | \
    tee /etc/apt/sources.list.d/nodesource.list > /dev/null && \
  # Install Packages
  apt-get update && apt-get install -y \
    docker-ce-cli \
    nodejs \
    python3.14 \
    python3.14-venv \
    python3.14-dev && \
  # Update npm to latest
  npm install -g npm@latest && \
  # Passwordless Sudo Setup
  echo "abc ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99-passwordless-sudo && \
  chmod 0440 /etc/sudoers.d/99-passwordless-sudo && \
  # Cleanup
  apt-get clean && rm -rf /var/lib/apt/lists/*