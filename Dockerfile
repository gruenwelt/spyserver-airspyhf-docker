# syntax=docker/dockerfile:1.4

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies and runtime libraries
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    pkg-config \
    libusb-1.0-0-dev \
    libusb-1.0-0 \
    tar \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/spyserver

# Copy all local files (including spyserver-arm64.tar) into container
COPY . .

# Add GitHub to known_hosts so SSH clone doesn't fail
RUN mkdir -p ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# Clone libairspyhf over SSH using BuildKit
RUN --mount=type=ssh git clone git@github.com:airspy/airspyhf.git

# Build and install libairspyhf
WORKDIR /opt/spyserver/airspyhf
RUN mkdir build && cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig

# Remove build dependencies but keep runtime libraries
RUN apt-get remove -y build-essential cmake pkg-config libusb-1.0-0-dev git && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Extract the spyserver binary archive provided by the user
WORKDIR /opt/spyserver
RUN tar -xvf spyserver-arm64.tar

EXPOSE 5555

CMD ["./spyserver", "spyserver.config"]
