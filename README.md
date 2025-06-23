# spyserver-airspyhf-docker

A minimal Docker container that builds and installs the `libairspyhf` driver for Airspy HF+ and runs the precompiled `spyserver` in a container.

Tested to run on Orange Pi Zero 2W, should be able to run on other arm64 single-board computers like Raspberry Pi

## Prerequisites

- A Linux system with Docker >= 20.10
- Docker BuildKit enabled
- An SSH key registered with your GitHub account
- The spyserver file `spyserver-arm64.tar` downloaded from https://airspy.com/download and placed in the same folder as the Dockerfile

## Enable BuildKit

Enable BuildKit temporarily in your shell:

export DOCKER_BUILDKIT=1

Or persist it globally:

echo "export DOCKER_BUILDKIT=1" >> ~/.bashrc

## SSH Setup

Ensure `ssh-agent` is running and your GitHub SSH key is loaded:

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

Test GitHub SSH access:

ssh -T git@github.com

## Build the Docker image

docker build --ssh default -t spyserver-airspyhf .

## Run the container

docker run -it \
  --name spyserver-airspyhf-container \
  --device=/dev/bus/usb \
  -p 5555:5555 \
  spyserver-airspyhf

## Notes

- This image supports Airspy HF+ and HF+ Discovery.
- You must manually download and provide the `spyserver-arm64.tar` file.
- The container exposes port 5555 for remote SDR clients like SDR# or SDR++.
