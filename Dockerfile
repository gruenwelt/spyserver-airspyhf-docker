# syntax=docker/dockerfile:1.4

# --- Build Stage ---
FROM debian:bookworm-slim AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    pkg-config \
    libusb-1.0-0-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

# Clone and build libairspyhf
RUN git clone --depth 1 https://github.com/airspy/airspyhf.git && \
    mkdir airspyhf/build && cd airspyhf/build && \
    cmake .. && make -j$(nproc) && make install

# Strip the built shared library
RUN strip /usr/local/lib/libairspyhf.so.1.8.0

# --- Runtime Stage ---
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    libusb-1.0-0 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/spyserver

# Copy only the built library and headers
COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/include /usr/local/include

# Copy the spyserver tar and unpack it
COPY spyserver*.tar ./
RUN tar -xvf spyserver*.tar && rm spyserver*.tar

# Configure dynamic linker
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/local-lib.conf && ldconfig

EXPOSE 5555

CMD ["./spyserver", "spyserver.config"]
