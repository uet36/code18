
FROM mcr.microsoft.com/vscode/devcontainers/base:0-focal

ENV DEBIAN_FRONTEND=noninteractive

# Install system packages commonly used in CS50-like environments
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    build-essential \
    gcc \
    g++ \
    clang \
    make \
    cmake \
    pkg-config \
    python3 \
    python3-venv \
    python3-pip \
    python3-dev \
    git \
    curl \
    wget \
    unzip \
    zip \
    sqlite3 \
    postgresql-client \
    default-jdk \
    openjdk-11-jdk \
    nodejs \
    npm \
    golang \
  && rm -rf /var/lib/apt/lists/*

# Update python symlink
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1 || true

# Install GitHub CLI
RUN type -p curl >/dev/null || (apt-get update && apt-get install -y curl) \
  && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
  && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && apt-get update && apt-get install -y gh \
  && rm -rf /var/lib/apt/lists/*

# Install pipx and useful Python tools
RUN python -m pip install --upgrade pip \
  && python -m pip install pipx \
  && python -m pipx ensurepath || true

# Install nvm and rustup in /usr/local (postCreateCommand also installs user-local toolchains)
RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash || true \
  && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || true

WORKDIR /workspace
