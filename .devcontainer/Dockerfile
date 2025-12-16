FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    clang \
    make \
    python3 \
    python3-pip \
    git \
    curl \
    wget \
    nodejs \
    npm \
    default-jdk \
  && rm -rf /var/lib/apt/lists/*

# Create a non-root user 'vscode' is provided by base image; ensure pip points to python3
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1 || true

WORKDIR /workspace
