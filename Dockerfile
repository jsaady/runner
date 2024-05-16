FROM ghcr.io/actions/actions-runner:latest

USER root

# Install basic tools
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    git \
    jq \
    build-essential \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

RUN install -m 0755 -d /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && chmod a+r /etc/apt/keyrings/docker.asc

RUN echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu jammy stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker CE:
RUN apt-get update && apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Enable experimental features (may not be necessary if already enabled globally)
RUN mkdir -p ~/.docker && echo '{"experimental": "enabled"}' > ~/.docker/config.json

# Install Buildx if not already included
# RUN docker buildx create --name mybuilder --use

# Assuming the runner user is `runner`, modify as necessary
RUN usermod -aG docker runner

USER runner
