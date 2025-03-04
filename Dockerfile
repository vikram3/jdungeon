FROM ubuntu:22.04

# Set the working directory
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    git-lfs \
    unzip \
    wget \
    zip \
    adb \
    openjdk-11-jdk-headless \
    rsync \
    dotnet-sdk-7.0 \
    && rm -rf /var/lib/apt/lists/*

# Copy your Godot project to the container
COPY ./build/linux/ /app/

ENTRYPOINT ["/app/jdungeon.x86_64", "--headless", "j_server"]
