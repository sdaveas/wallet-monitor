# Use Ubuntu as base image since fswatch isn't available in Alpine
FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    jq \
    bc \
    diffutils \
    procps \
    inotify-tools \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy all shell scripts
COPY *.sh ./
COPY .env ./

# Replace macOS-specific alert.sh with Linux-compatible version
COPY alert-linux.sh ./alert.sh

# Make scripts executable
RUN chmod +x *.sh

# Create directory for stats files
RUN mkdir -p /app/data

# Set environment variables
ENV STATS_DIR=/app/data

# Default command
CMD ["./job.sh"]
