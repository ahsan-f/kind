# Use a base image that includes a recent version of Ubuntu or similar Linux distribution
# Docker-in-Docker (dind) is often used for CI runners that need to run Docker inside the container,
# but using the host's Docker daemon (docker-out-of-docker or dind-rootless) is also common.
# For simplicity and broad compatibility, we'll use a standard image and install dependencies.

FROM ubuntu:22.04

# Install necessary packages: docker, curl, git, make, etc.
# We're installing the Docker CLI here, but the Docker daemon itself needs to be available
# on the runner for kind to function. For GitHub Actions' default runner, Docker is pre-installed.
RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    make \
    gnupg2 \
    software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install kind
# Note: You should check for the latest stable kind version
ENV KIND_VERSION v0.20.0 
RUN curl -Lo ./kind https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64 && \
    chmod +x ./kind && \
    mv ./kind /usr/local/bin/kind

# Set default command if you intend to use this as a simple runner
# For CI, you usually use a specific entrypoint in your workflow, so this is optional.
# CMD ["/bin/bash"]
