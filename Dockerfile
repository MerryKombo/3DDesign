FROM debian:sid-20221205-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    openscad \
    xvfb \
    && rm -rf /var/lib/apt/lists/*